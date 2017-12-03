Pictures = React.createClass({
  getInitialState(){
    return{
      pictures: JSON.parse(this.props.pictures),
      modal_picture: false,
      zoom_loupe: false
    }
  },
  showModalView(picture){
    this.setState({modal_picture: this.preloadImage(picture)})
  },
  changePictureModal(index){
    picture = this.state.pictures[index]
    if (picture != undefined)
      this.setState({modal_picture: this.preloadImage(picture)})
  },
  switchZoomLoupe(){
    this.setState({zoom_loupe: !this.state.zoom_loupe})
  },
  preloadImage(picture){
    return{...picture,
        ['image']: Object.assign({}, picture.image, {url: picture.image.url || 'images/no_image_found_large.jpg',
          thumb: {url: picture.image.thumb.url || 'images/no_image_found.jpg'}})
      }
  },
  componentWillMount(){
    window.Picture = {
      updatePicture: function (data = '') {
        if (data == '') return
        picture = JSON.parse(data)
        index = this.state.pictures.findIndex((p) => p.id == picture.id)
        if (index < 0) return
        new_pictures = this.state.pictures
        new_pictures[index] = Object.assign({}, this.state.pictures[index], picture)
        this.setState({pictures: new_pictures})
      }.bind(this)
    }
  },
  render(){
    last_next_index = this.state.pictures.length - 1
    that = this
    return(
        <div>
          {
            this.state.pictures.map(function (pict, index) {
              if (index > 0) pict.previous_index = (index - 1).toString()
              if (index < last_next_index) pict.next_index = index + 1
              return <PictureItem key={index} index={index} picture={that.preloadImage(pict)} showModalView={that.showModalView}/>
            })
          }
          <div className="modal fade" id="picture-modal-show" tabIndex="-1" role="dialog" aria-labelledby= "modal-label">
            {this.state.modal_picture &&
              <PictureModalShow picture={this.state.modal_picture}
                                zoom_loupe={this.state.zoom_loupe}
                                changePictureModal={this.changePictureModal}
                                switchZoomLoupe={this.switchZoomLoupe}/>
            }
          </div>
        </div>
    )
  }
})


PictureItem = React.createClass({
  getInitialState(){
    return{
            picture: this.props.picture
          }
  },
  showModalView(e){
    this.props.showModalView(this.props.picture)
  },
  render(){
    return(
        <div className='picture-block'>
          <div className='image-block'>
            <a href="#" data-toggle="modal" data-target={`#picture-modal-show`} onClick={this.showModalView}>
              <img className="image-space" src={this.props.picture.image.thumb.url} alt="No image"/>
            </a>
          </div>
          <div className="picture-action">
            <a href="#" data-toggle="modal" data-target={`#picture-modal-show`} onClick={this.showModalView}>
              <span className="glyphicon glyphicon-zoom-in"></span>
            </a>
            <a data-confirm="Are you sure?" title="Delete" rel="nofollow" data-method="delete" href={`/pictures/${this.props.picture.id}`}>
              <span className="glyphicon glyphicon-trash"></span>
            </a>
          </div>
          <div className="picture-title">{this.props.picture.title}</div>
        </div>
    )
  }
})

