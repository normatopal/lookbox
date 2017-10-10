// hack to escape turbolinks Warning: unmountComponentAtNode(): The node you're attempting to unmount was rendered by another copy of React
// fixed from version 2.0 'react-rails'
ReactRailsUJS.handleEvent('turbolinks:before-cache', function() {window.ReactRailsUJS.unmountComponents()});

LookPictures = React.createClass({
  getInitialState: function () {
    let look_pictures = JSON.parse(this.props.look_pictures)
    return {
      look_pictures: look_pictures,
      max_position_order: look_pictures.length
    }
  },
  findPictureById: function(pictures, picture_id, field_name){
    return pictures.find((picture) => { if (picture[field_name] == picture_id) return picture })
  },
  removePicture: function(lp_remove_id){
    let look_pictures = this.state.look_pictures.slice()
    let lp_remove = this.findPictureById(look_pictures, lp_remove_id, 'id')
    look_pictures.splice(look_pictures.indexOf(lp_remove), 1)
    this.setState({look_pictures: look_pictures})
  },
  changePositionParams: function(pict_id, position_params){
    let look_pictures = this.state.look_pictures.slice()
    let lp = this.findPictureById(look_pictures, pict_id, 'picture_id')
    look_pictures[look_pictures.indexOf(lp)]['position_params'] = position_params
    this.setState({look_pictures: look_pictures})
  },
  changeMaxPositionOrder: function(){
    this.setState({max_position_order: this.state.max_position_order + 1})
    return this.state.max_position_order
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
                                  changePositionParams = {this.changePositionParams}
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
        <div id={`look-picture-${this.props.picture.id}-position`}>
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
  },
  undoPictureRemove: function(e){
    this.setState({show_item: true})
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
               <span className="glyphicon glyphicon-trash" title="Delete" style={{zIndex: this.state.position_params['order'] }} onClick={this.removePicture}></span>
            </div>
          </Draggable>
          }
          {!this.state.show_item &&
            <div className="undo-picture-remove">
                 <span className="glyphicon glyphicon-arrow-left" title="Undo removing"
                       style={{zIndex: this.state.position_params['order'] + this.state.removed_pictures_counter }} onClick={this.undoPictureRemove}></span>
            </div>
          }
          { this.setHiddenFields() }
        </div>
    )
  }
})

