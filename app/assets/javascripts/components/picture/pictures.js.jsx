//cl = cloudinary.Cloudinary.new({cloud_name: "lookbox"})
//cl.responsive()

Pictures = React.createClass({
  getInitialState(){
    return{
      pictures: JSON.parse(this.props.pictures),
      modal_picture: false,
      zoom_loupe: false
    }
  },
  showModalView(picture){
    this.setState({modal_picture: picture})
  },
  changePictureModal(index){
    picture = this.state.pictures[index]
    this.setState({modal_picture: this.preloadImage(picture)})
  },
  switchZoomLoupe(){
    this.setState({zoom_loupe: !this.state.zoom_loupe})
  },
  preloadImage(picture){
    return{...picture,
       ['image']: {large: {url: this.setImageTimeStamp(picture.image.large.url, picture.image_timestamp) || `images/${ConstantsList.Images.noImageLarge}`},
          thumb: {url: this.setImageTimeStamp(picture.image.thumb.url) || `images/${ConstantsList.Images.noImageSmall}`}},
        ['has_image']: Boolean(picture.image.url)
      }
  },
  setImageTimeStamp(url, image_timestamp){
    if (image_timestamp && url) url += '?v=' + image_timestamp
    return url
  },
  componentWillMount(){
    window.Picture = {
      updatePicture: function (data = '') {
        if (data == '') return
        picture = JSON.parse(data)
        index = this.state.pictures.findIndex((p) => p.id == picture.id)
        if (index < 0) return
        new_pictures = this.state.pictures
        new_pictures[index] = Object.assign({}, this.state.pictures[index], picture) // this.setImageTimeStamp(picture) for image refresh from local store
        this.setState({pictures: new_pictures})
      }.bind(this)
    }
  },
  render(){
    that = this
    return(
        <div>
          {
            this.state.pictures.map(function (pict, index) {
              if (index > 0) pict.previous_index = (index - 1).toString()
              if (index < that.state.pictures.length - 1) pict.next_index = index + 1
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
    //$.cloudinary.image(this.props.picture.image.thumb.url, {angle: -30, opacity: 70})
    //picture_transformed = cl.imageTag(this.props.picture.file_name, {crop: 'scale', width: 150, height: 150, angle: 0}).toHtml()
    //<span dangerouslySetInnerHTML={{__html:  picture_transformed}} />
    //or for simple string cl.url(this.props.picture.file_name, {crop: 'scale', width: 150, height: 150, angle: 0})
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

