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
    if (picture != undefined)
      this.setState({modal_picture: picture})
  },
  switchZoomLoupe(){
    this.setState({zoom_loupe: !this.state.zoom_loupe})
  },
  componentWillMount(){
    window.Picture = {
      updatePicture: function (data = '') {
        if (data == '') return
        picture = JSON.parse(data)
        index = this.state.pictures.findIndex((p) => p.id == picture.id)
        if (index > -1)
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
              return <PictureItem key={index} index={index} picture={pict} showModalView={that.showModalView}/>
            })
          }
          <div className="modal fade" id="picture-modal-show" tabIndex="-1" role="dialog" aria-labelledby= "modal-label">
            {this.state.modal_picture &&
              <PictureModalShow picture={this.state.modal_picture}
                                zoom_loupe={this.state.zoom_loupe}
                                changePictureModal={this.changePictureModal}
                                switchZoomLoupe={this.switchZoomLoupe}

              />
            }
          </div>
        </div>
    )
  }
})


PictureItem = React.createClass({
  getInitialState(){
    return{
      picture: {...this.props.picture,
                ['image']: Object.assign({}, {thumb: {url: 'images/no_image_found.jpg'}}, this.props.picture.image )
      }
    }
  },
  showModalView(e){
    this.props.showModalView(this.state.picture)
  },
  render(){
    return(
        <div className='picture-block'>
          <div className='image-block'>
            <a href="#" data-toggle="modal" data-target={`#picture-modal-show`} onClick={this.showModalView}>
              <img className="image-space" src={this.state.picture.image.thumb.url} alt="No image"/>
            </a>
          </div>
          <div className="picture-action">
            <a href="#" data-toggle="modal" data-target={`#picture-modal-show`} onClick={this.showModalView}>
              <span className="glyphicon glyphicon-zoom-in"></span>
            </a>
            <a data-confirm="Are you sure?" title="Delete" rel="nofollow" data-method="delete" href={`/pictures/${this.state.picture.id}`}>
              <span className="glyphicon glyphicon-trash"></span>
            </a>
          </div>
          <div className="picture-title">{this.state.picture.title}</div>
        </div>
    )
  }
})

