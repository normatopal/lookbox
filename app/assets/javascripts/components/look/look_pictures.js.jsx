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
  changeMaxPositionOrder: function(){
    this.setState({max_position_order: this.state.max_position_order + 1})
    return this.state.max_position_order
  },
  render: function() {
    return(
      <div>
        { this.state.look_pictures.map(function(el, index){
          return <LookPictureItem key={el.id} lp_id={el.id} index = {index}
                                  picture = {el.picture} position_params = {el.position_params}
                                  changeMaxPositionOrder = {this.changeMaxPositionOrder}
                                  removePicture = {this.removePicture}/>}.bind(this)) }
      </div>
    )
  }
})

LookPictureItem =  React.createClass({
  getDefaultProps: function () {
    return { position_params: {left: 0, top: 0, order: 0}  }
  },
  getInitialState: function () {
    return {
      position_params: this.props.position_params,
      hidden_fields: { 'id': this.props.lp_id, 'picture_id': this.props.picture.id, '_destroy': "false" }
    }
  },
  setHiddenFields: function(){
    var fields = {'id': this.props.lp_id, 'picture_id': this.props.picture.id, '_destroy': "false", 'order': 0, 'left' : 0, 'top': 0}
    return(
        <div id={`look-picture-${this.props.picture.id}-position`}>
          { Object.keys(fields).map((key) => {
            let name_prefix = (key in this.state.position_params) ? 'position_' : ''
            let elem_id = `look_look_pictures_attributes_${this.props.index}_id`
            return <input type="hidden" key={`lp_${ this.props.lp_id}_${key}`}
                          value={this.state.position_params[key] || this.state.hidden_fields[key]}
                          name={`look[look_pictures_attributes][${this.props.index}][${name_prefix}${key}]`}
                          id={elem_id} ref={elem_id} /> }) }
        </div>
    )
  },
  changePositionParams: function(position){
    this.setState({ position_params: {...this.state.position_params, ...position } })
  },
  increaseZindex: function(){
    this.setState({ position_params: {...this.state.position_params, ['order']: this.props.changeMaxPositionOrder() } })
  },
  removePicture: function(e){
    e.stopPropagation()
    this.props.removePicture(this.props.lp_id)
  },
  render: function(){
    return(
        <div className = 'look-picture-block'>
          <Draggable position = {this.props.position_params} canvas_id = "look-canvas"
                     changePositionParams = { this.changePositionParams } increaseZindex = { this.increaseZindex }>
            <img className = "" src={`${this.props.picture.image.url}`} title = ''
                 style = {{ position: 'relative', width: 'auto', height: '200px',
                 zIndex: this.state.position_params['order'] }} onClick = {this.increaseZindex} />
            <div className = "picture-action">
               <span className = "glyphicon glyphicon-trash" title = "Delete"
                     style = {{zIndex: this.state.position_params['order'] }} onClick = {this.removePicture}></span>
            </div>
          </Draggable>
          { this.setHiddenFields() }
        </div>
    )
  }
})

LookPictureHiddenField = React.createClass({
  getInitialState: function () {
    return { fieldValue: this.props.fieldValue };
  },
  render: function() {
    return <input type="hidden" value={this.state.fieldValue}
                  name={`look[look_pictures_attributes][${this.props.index}][${this.props.fieldName}]`}
                  id={`look_look_pictures_attributes_${this.props.index}_id`}/>
  }
})

