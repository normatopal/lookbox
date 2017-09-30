LookUsers = React.createClass({
  getInitialState: function() {
    return {
      shared_users: JSON.parse(this.props.shared_users),
      potential_users: JSON.parse(this.props.potential_users),
    }
  },
  findUserById: function(users, user_id, field_name){
    return users.find((user) => { if (user[field_name] == user_id) return user })
  },
  removeSharedUser: function(e){
    e.preventDefault()
    var sharedUsers = this.state.shared_users.slice()
    existedUser = this.findUserById(sharedUsers, e.target.attributes.getNamedItem('data-user-id'))
    sharedUsers.splice(sharedUsers.indexOf(existedUser), 1)
    this.setState({shared_users: sharedUsers})
  },
  addSharedUser: function(e){
    userId = e.target.attributes.getNamedItem('data-user-id').value
    sharedUser = this.findUserById(this.state.shared_users, userId, 'user_id')
    if (sharedUser == undefined) {
      sharedUser = this.findUserById(this.state.potential_users, userId, 'id')
      this.setState({shared_users: this.state.shared_users.concat({id: 'new-look-user-'.concat(sharedUser.id), user_id: sharedUser.id,user: sharedUser})})
    }
    else{
      userItem = this.refs['user-item-'.concat(sharedUser.user_id)]
      if (userItem.state.isDestroy){
        userItem.toogleDestroy(e)
      }
    }
  },
  render: function() {
    addSharedUser = this.addSharedUser
    removeSharedUser = this.removeSharedUser
    return(
        <div>
          <UserField potential_users = {this.state.potential_users} addSharedUser = {addSharedUser}/>
          <div id='shared-users-list'>
            { this.state.shared_users.map(function(el, index){ return <UserItem key={el.id} ref={`user-item-${el.user.id}`} index = {index} user_look_id = {el.id} user = {el.user} removeSharedUser = {this.removeSharedUser}/>}) }
          </div>
        </div>
    )
  }
});

UserItem = React.createClass({
  getInitialState: function() {
    return {isDestroy: false};
  },
  toogleDestroy: function(e){
    e.preventDefault()
    this.setState({ isDestroy: !this.state.isDestroy })
  },
  render: function(){
    userLookInput = ""
    removeUserMethod = this.props.removeSharedUser
    if (this.props.user_look_id.toString().indexOf('new-look-user') == -1){
      removeUserMethod = this.toogleDestroy
      user_look_input = (<input id={`look_user_looks_attributes_${this.props.index}_id`} name={`look[user_looks_attributes][${this.props.index}][id]`} type='hidden' value={this.props.user_look_id}/>)
    }
    return(
        <div id={`shared-user-id-${this.props.user.id }`}>
          { userLookInput }
          <input id={`look_user_looks_attributes_${this.props.index }_user_id`} name={`look[user_looks_attributes][${this.props.index}][user_id]`} type='hidden' value= { this.props.user.id}/>
          <UserLook index = {this.props.index} isDestroy = {this.state.isDestroy} />
          <div className = 'look-user-item'> <a onClick={ removeUserMethod }style = {{display: this.props.hide[this.state.isDestroy] }} title='Click to Remove'>{ this.props.user.email }</a></div>
        </div>
    )
  }
})

UserItem.defaultProps = {
  hide: {
    true: 'none',
    false: 'block'
  }
}

UserLook = React.createClass({
  render: function(){
    return(
        <input id={`look_user_looks_attributes_${this.props.index}__destroy`} name={`look[user_looks_attributes][${this.props.index}][_destroy]`} type='hidden' value={this.props.isDestroy}/>
    )
  }
})

UserField = React.createClass({
  getInitialState: function() {
    return {filtered_users: [], current_user: "", potential_users: this.props.potential_users}
  },
  filterUsers: function(e) {
    var filtered_users = [];
    var part_name = e.target.value;
    if (part_name != "") {
      filtered_users = this.state.potential_users.filter(function (user) {
        if (user.email.indexOf(part_name) > -1) return user;
      });
    }
    this.setState({current_user: part_name});
    this.setState({filtered_users: filtered_users});
  },
  fillUserField: function(e){
    this.setState({current_user: e.currentTarget.textContent});
    this.setState({filtered_users: []});
    this.props.addSharedUser(e)
  },
  clearUserField: function(e){
    this.setState({current_user: ""})
  },
  render: function(){
    var fillUserField = this.fillUserField
    return(
        <div>
          <div className="text-input-wrapper" >
            <input id="user-autocomplete" type="text" value= {this.state.current_user} onChange={this.filterUsers}/>
            <span className="clear-input-btn" title="Clear" onClick={ this.clearUserField } style={{visibility: this.props.visibility[this.state.current_user.length === 0]}}>&times;</span>
          </div>
          <div>
            { this.state.filtered_users.map(function(user){
              return(<FilteredUser key={user.id} user={user} fillUserField={fillUserField}/>) })
            }
          </div>
        </div>
    )
  }
});

UserField.defaultProps = {
  visibility:{
    true: 'hidden',
    false: 'visible'
  }
}

FilteredUser = React.createClass({
  render: function() {
    return (<div className='look-user-item'><a onClick={this.props.fillUserField} data-user-id={this.props.user.id} title='Share'>{this.props.user.email}</a></div> )
  }
})