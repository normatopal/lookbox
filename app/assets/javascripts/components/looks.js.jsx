User = React.createClass({
  getInitialState: function() {
    return {isDestroy: false, isVisible: 'block'};
  },
  toogleDestroy: function(e){
    e.preventDefault()
    this.setState({ isDestroy: !this.state.isDestroy });
    this.setState({ isVisible: this.state.isDestroy ? 'block' : 'none' });
  },
  render: function(){
    return(
        <div id={`shared-user-id-${this.props.user.id }`}>
          <input id={`look_user_looks_attributes_${this.props.index }_user_id`} name={`look[user_looks_attributes][${this.props.index}][user_id]`} type='hidden' value= { this.props.user.id}/>
          <UserLook index = {this.props.index} isDestroy = {this.state.isDestroy} />
          <a href='#' onClick={ this.toogleDestroy } style = {{display: this.state.isVisible }}>{ this.props.user.email }</a>
        </div>
    )
  }
})

UserLook = React.createClass({
  render: function(){
    return(
      <input id={`look_user_looks_attributes_${this.props.index}__destroy`} name={`look[user_looks_attributes][${this.props.index}][_destroy]`} type='hidden' value={this.props.isDestroy}/>
    )
  }
})

SharedUsers = React.createClass({
  getInitialState: function() {
    return {users: []};
  },
  removeUser: function(e){
    debugger
    e.preventDefault()
    var newUsers = this.state.users.slice()
    newUsers.splice(0,1)
    this.setState({users: newUsers});
  },
  componentWillMount: function(){
    this.setState({users: JSON.parse(this.props.shared_users)})
  },
  render: function() {
    removeUser = this.removeUser
    return(
      <div id='shared-users-list11'>
        { this.state.users.map(function(el, index){ return <User key={el.id} index = {index} user = {el.user} removeUser = {removeUser}/>}) }
      </div>
    )
  }
});