PictureModalShow = React.createClass({
  getInitialState(){
    return {
      picture: this.props.picture
    }
  },
  switchZoomLoupe(e){
    this.props.switchZoomLoupe()
    e.preventDefault()
  },
  setZoomLoupe(){
    image_node = $(ReactDOM.findDOMNode(this)).find('.show-picture-image')
    if(this.props.zoom_loupe){
      $(".zoomContainer").remove()
      image_node.removeData("elevateZoom")
      image_node.data('zoom-image', this.props.picture.image.large.url).elevateZoom(ConstantsList.ZoomLoupeOptions)
    }
    else{
      image_node.removeData("elevateZoom")
      $(".zoomContainer").remove()
    }
  },
  previousPicture(){
    this.props.changePictureModal(this.props.picture.previous_index)
  },
  nextPicture(){
    this.props.changePictureModal(this.props.picture.next_index)
  },
  closeModalShow(){
    if ($(".zoomContainer").remove().length > 0)
      this.props.switchZoomLoupe()
  },
  componentDidUpdate(){
    this.setZoomLoupe()
  },
  componentWillMount(){
    // add event listener for clicks
    document.addEventListener('click', this.handleOutsideClick, false);
  },
  componentWillUnmount: function() {
    // make sure you remove the listener when the component is destroyed
    document.removeEventListener('click', this.handleOutsideClick, false);
  },
  handleOutsideClick: function(e){
    if(!ReactDOM.findDOMNode(this).contains(e.target)) {
      this.closeModalShow()
    }
  },
  render(){
    return(
          <div className="modal-dialog" role="document">
            <div className="modal-content">
              <div className="modal-header">
                <button className="close" aria-label="Close" data-dismiss='modal' type="button">
                  <span aria-hidden='true' onClick={this.closeModalShow}>×</span>
                </button>
                <h4 className="modal-title"><strong>{this.props.picture.title}</strong></h4>
                <div className="modal-description">{this.props.picture.description}</div>
              </div>
              <div className="modal-body picture-show">
                <div className="row">
                  <div className="col-sm-4">
                    { this.props.picture.previous_index &&
                    <span className="btn-left" title="Previous image" onClick={this.previousPicture}></span>
                    }
                  </div>
                  <div className="col-sm-4">
                    { this.props.picture.has_image &&
                    <a href="#" className={`btn-zoom-loupe ${this.props.zoom_loupe ? 'disable' : ''}`}
                       title="Click to on/off loupe" onClick={this.switchZoomLoupe}> </a>
                    }
                  </div>
                  <div className="col-sm-4">
                    { this.props.picture.next_index &&
                    <span className="btn-right" title="Next image" onClick={this.nextPicture}></span>
                    }
                  </div>
                </div>
                <div className="row">
                  <img className="show-picture-image" src={this.props.picture.image.large.url} data-zoom-image={this.props.picture.image.large.url} alt="No image"/>
                </div>
              </div>
              <div className="modal-footer">
                <a href={`/pictures/${this.props.picture.id}/copy`} className="btn btn-sm btn-primary btn-footer-left" data-remote="true" data-toggle="modal" data-target={`#picture-modal-show`}><span className="glyphicon glyphicon-copy"></span>Make a copy</a>
                <a href={`/pictures/${this.props.picture.id}/edit`} className="btn btn-sm btn-primary" data-remote="true" data-toggle="modal" data-target={`#picture-modal-show`}><span className="glyphicon glyphicon-pencil"></span>Edit</a>
                <a href={`/pictures/${this.props.picture.id}`} className="btn btn-sm btn-danger" data-method="delete" data-confirm="Are you sure?"><span className="glyphicon glyphicon-trash"></span>Delete</a>
              </div>
            </div>
          </div>
    )
  }
})



