// hack to escape turbolinks Warning: unmountComponentAtNode(): The node you're attempting to unmount was rendered by another copy of React
// fixed from version 2.0 'react-rails'
ReactRailsUJS.handleEvent('turbolinks:before-cache', function() {window.ReactRailsUJS.unmountComponents()});

LookPictures = React.createClass({
  getInitialState: function () {
    let look_pictures = JSON.parse(this.props.look_pictures)
    return {
      look_pictures: look_pictures,
      max_position_order: look_pictures.length,
      pictures_for_remove_count: 0
    }
  },
  findPictureById: function(look_pictures, picture_id, field_name){
    return look_pictures.find((lp) => { if (lp.picture_id == picture_id) return lp })
  },
  changePositionParams: function(picture_id, position_params){
    let look_pictures = this.state.look_pictures.slice()
    let lp = this.findPictureById(look_pictures, picture_id)
    look_pictures[look_pictures.indexOf(lp)]['position_params'] = position_params
    this.setState({look_pictures: look_pictures})
  },
  changeMaxPositionOrder: function(){
    this.setState({max_position_order: this.state.max_position_order + 1})
    return this.state.max_position_order
  },
  changePicturesForRemoveCount: function(counter){
    this.setState({pictures_for_remove_count: this.state.pictures_for_remove_count + counter})
    return this.state.pictures_for_remove_count
  },
  duplicatePicture: function(picture_id){
    new_look_picture = this.findPictureById(this.state.look_pictures, picture_id)
    new_look_picture.id = ''
    new_look_picture.position_params = {left: new_look_picture.position_params.left - 30, top: new_look_picture.position_params.top - 30, order: new_look_picture.position_params.order  }
    this.setState({look_pictures: this.state.look_pictures.concat(new_look_picture)})
  },
  componentWillMount(){
    window.Look = {
      addPictures: (data='') => {
        this.setState({look_pictures: this.state.look_pictures.concat(JSON.parse(data))})
      }
    }
  },
  render: function() {
    return(
      <div>
        { this.state.look_pictures.map(function(el, index){
          return <LookPictureItem key={`lp_${index}`} lp_id={el.id} index = {index}
                                  picture = {el.picture} position_params = {el.position_params}
                                  pictures_for_remove_count = {this.state.pictures_for_remove_count}
                                  duplicatePicture = {this.duplicatePicture}
                                  changePositionParams = {this.changePositionParams}
                                  changePicturesForRemoveCount = {this.changePicturesForRemoveCount}
                                  changeMaxPositionOrder = {this.changeMaxPositionOrder}/>}.bind(this)) }
      </div>
    )
  }
})

LookPictureItem =  React.createClass({
  getDefaultProps: function () {
    return { lp_id: ''}
  },
  getInitialState: function () {
    return {
      show_item: true,
      removed_pictures_counter: 0,
      position_params:  Object.assign({}, {left: '0', top: '0', order: '0'}, this.props.position_params),
      hidden_fields: { 'id': this.props.lp_id, 'picture_id': this.props.picture.id, '_destroy': false }
    }
  },
  componentWillMount(){
    if (this.props.lp_id =='') this.increaseZindex()
  },
  setHiddenFields: function(){
    //var fields = {'id': this.props.lp_id, 'picture_id': this.props.picture.id, '_destroy': !this.state.show_item, 'order': 0, 'left' : 0, 'top': 0}
    return(
        <div id={`look-picture-${this.props.picture.id}-position-${this.props.index}`}>
          { Object.keys(this.state.hidden_fields).concat(Object.keys(this.state.position_params)).map((field_name) => {
            let name_prefix = (field_name in this.state.position_params) ? 'position_' : ''
            return <input type="hidden"
                          key={`lp_hidden_${ this.props.index}_${field_name}`}
                          value={field_name == '_destroy' ? !this.state.show_item : (this.state.position_params[field_name] || this.state.hidden_fields[field_name])}
                          name={`look[look_pictures_attributes][${this.props.index}][${name_prefix}${field_name}]`}
                          id={`look_look_pictures_attributes_${this.props.index}_${name_prefix}${field_name}`} /> }) }
        </div>
    )
  },
  changePositionParams: function(position){
    this.setState({ position_params: {...this.state.position_params, ...position } })
    this.props.changePositionParams(this.props.picture.id, position)
  },
  increaseZindex: function(){
    this.setState({ position_params: {...this.state.position_params, ['order']: this.props.changeMaxPositionOrder() } })
  },
  removePicture: function(e){
    e.stopPropagation()
    this.setState({show_item: false})
    this.props.changePicturesForRemoveCount(1)
    look_pictures_ids = $.cookie('look_pictures_ids').split(',')
    index = $.inArray(this.props.picture.id.toString(), look_pictures_ids)
    if (index >= 0) {
      look_pictures_ids.splice(index, 1)
      $.cookie('look_pictures_ids', look_pictures_ids.join(','), {path: '/'})
    }
  },
  duplicatePicture: function(e){
    this.props.duplicatePicture(this.props.picture.id)
  },
  undoPictureRemove: function(e){
    this.setState({show_item: true})
    this.props.changePicturesForRemoveCount(-1)
  },
  render: function(){
    return(
        <div className = 'look-picture-block'>
          { this.state.show_item &&
          <Draggable position={this.props.position_params} canvas_id="look-canvas"
                     changePositionParams={ this.changePositionParams } increaseZindex={ this.increaseZindex }>
            <img className="" src={`${this.props.picture.image.url}`} title=''
                 style={{ position: 'relative', width: 'auto', height: '200px',
                 zIndex: this.state.position_params['order'] }} onClick={this.increaseZindex}/>
            <div className="picture-action">
               <span className="glyphicon glyphicon-duplicate" title="Make a copy" style={{zIndex: this.state.position_params['order'] }} onClick={this.duplicatePicture}></span>
               <span className="glyphicon glyphicon-trash" title="Delete" style={{zIndex: this.state.position_params['order'] }} onClick={this.removePicture}></span>
            </div>
          </Draggable>
          }
          {!this.state.show_item &&
            <div className="undo-picture-remove">
                 <span className="glyphicon glyphicon-arrow-left" title="Undo removing"
                       style={{zIndex: this.state.position_params['order'] + this.state.removed_pictures_counter }} onClick={this.undoPictureRemove}></span>
                 <span title=" to restore" style={{backgroundColor: 'white'}}><b>{this.props.pictures_for_remove_count}</b>item(s)</span>
            </div>
          }
          { this.setHiddenFields() }
        </div>
    )
  }
})

