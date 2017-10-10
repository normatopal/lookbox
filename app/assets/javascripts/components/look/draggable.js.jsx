var Draggable = React.createClass({
  getDefaultProps: function () {
    return {
      // allow the initial position to be passed in as a prop
      position: {left: 0, top: 0},
      canvas_id: null
    }
  },
  getInitialState: function () {
    return {
      position: this.props.position,
      dragging: false,
      canvas_offset: this.getCanvasOffset(this.props.canvas_id),
      rel: null // position relative to the cursor
    }
  },
  getCanvasOffset: function(canvas_id){
    let canvas_offset = {left: 0, top: 0}
    let canvas_elem = document.getElementById(canvas_id)
    if (canvas_elem) {
      let canvas_offset_elem = canvas_elem.getBoundingClientRect()
      canvas_offset = {left: canvas_offset_elem.left, top: canvas_offset_elem.top}
    }
    return canvas_offset
  },
  componentDidUpdate: function (props, state) {
    if (this.state.dragging && !state.dragging) {
      document.addEventListener('mousemove', this.onMouseMove)
      document.addEventListener('mouseup', this.onMouseUp)
    } else if (!this.state.dragging && state.dragging) {
      document.removeEventListener('mousemove', this.onMouseMove)
      document.removeEventListener('mouseup', this.onMouseUp)
    }
  },
  componentDidMount: function() {
    document.addEventListener('scroll', this.handleScroll, false);
  },
  componentWillUnmount: function() {
    document.removeEventListener('scroll', this.handleScroll, false);
  },
  handleScroll: function(e){
      this.setState({canvas_offset: this.getCanvasOffset(this.props.canvas_id) })
  },
  onMouseDown: function (e) {
    // only left mouse button
    if (e.button !== 0) return
    let pos = ReactDOM.findDOMNode(this).getBoundingClientRect()
    this.setState({
      dragging: true,
      rel: {
        x: e.pageX - pos.left + this.state.canvas_offset.left,
        y: e.pageY - pos.top + this.state.canvas_offset.top
      }
    })
    this.props.increaseZindex()
    e.stopPropagation()
    e.preventDefault()
  },
  onMouseUp: function (e) {
    this.setState({dragging: false})
    this.props.changePositionParams(this.state.position)
    e.stopPropagation()
    e.preventDefault()
  },
  onMouseMove: function (e) {
    if (!this.state.dragging) return
    this.setState({
      position: {
        left: e.pageX - this.state.rel.x,
        top: e.pageY - this.state.rel.y
      }
    })
    e.stopPropagation()
    e.preventDefault()
  },

  render: function () {
    return(
        <div style={{ position: 'absolute', left: this.state.position.left + 'px', top: this.state.position.top + 'px'}}
             onMouseDown = {this.onMouseDown} >{this.props.children}</div>
    )
  }
})

