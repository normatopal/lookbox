//<div class="col-sm-6">
//  <input type="submit" name="commit" value="Save" id="look-save-btn" class="btn btn-primary">
//   <a class="btn btn-default" id="look-screenshot" title="Load screen to your locally" href="#">Make screenshot</a>
//</div>


LookPictureScreen = React.createClass({
  getInitialState: function () {
    return{
      screen_url: ''
    }
  },
  encode_image(callback){
    canvas_element = $('#' + ConstantsList.LookCanvasID)
    html2canvas(canvas_element, {
      useCORS: true, // for cross origin images
      onrendered: function (canvas) {
        callback(canvas.toDataURL(('image/png')))
      }
    })
  },
  makeScreenshot(e){
    e.preventDefault()
    this.encode_image((image_url) => {
      $("<a>", {href: image_url, download: $("#look_name").val()})
          .on("click", function(){ $(this).remove() }).appendTo("body")[0].click()
    })
    return false
  },
  saveScreenshot(e){
    e.persist() // allows pass event into callback
    e.preventDefault()
    this.timeout = setTimeout(function(){ this.timeout = null; e.nativeEvent.target.form.submit() }.bind(this), 5000) // wait for 5 second
    this.encode_image(((e, image_url) => {
      this.setState({screen_url: image_url})
      clearTimeout(this.timeout)
      this.timeout = null
      e.nativeEvent.target.form.submit()
    }).bind(this, e))
  },
  render(){
    return(
        <div>
          <input id="preview-image-url" value={this.state.screen_url} type="hidden" name="look[screen_attributes][image_encoded]"/>
          <input type="submit" name="commit" value="Save" id="look-save-btn" className="btn btn-primary" onClick={this.saveScreenshot}/>
          <a href="#" className="btn btn-default" id="look-screenshot" title="Download screen" onClick={this.makeScreenshot}>Screenshot</a>
        </div>
    )
  }
})