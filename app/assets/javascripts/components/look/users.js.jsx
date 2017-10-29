LookUsers = React.createClass({
  getInitialState: function() {
    return {
      shared_users: JSON.parse(this.props.shared_users),
      potential_users: JSON.parse(this.props.potential_users),
    }
  },
  findSharedUserById: function(look_users, user_id){
    return look_users.find((lu) => { if (lu.user.id == user_id) return lu })
  },
  findPotentialUserById: function(users, user_id){
    return users.find((u) => { if (u.id == user_id) return u })
  },
  removeSharedUser: function(e){
    e.preventDefault()
    sharedUsers = this.state.shared_users.slice()
    existedUser = this.findSharedUserById(sharedUsers, e.target.attributes.getNamedItem('data-user-id'))
    sharedUsers.splice(sharedUsers.indexOf(existedUser), 1)
    this.setState({shared_users: sharedUsers})
  },
  addSharedUser: function(e){
    user_id = e.target.attributes.getNamedItem('data-user-id').value
    sharedUser = this.findSharedUserById(this.state.shared_users, user_id)
    if (sharedUser == undefined) {
      potentialUser = this.findPotentialUserById(this.state.potential_users, user_id)
      this.setState({shared_users: this.state.shared_users.concat({id: 'new-look-user-'.concat(user_id), user: potentialUser})})
    }
    else{
      userItem = this.refs['user-item-'.concat(user_id)]
      if (userItem.state.isDestroy){
        userItem.toogleDestroy(e)
      }
    }
  },
  render: function() {
    return(
        <div className="shared-users-container">
          <UserField potential_users = {this.state.potential_users} addSharedUser = {this.addSharedUser}/>
          <div id='shared-users-list' className="shared-users-list">
            { this.state.shared_users.map(function(el, index){ return <UserItem key={el.id} ref={`user-item-${el.user.id}`} index = {index} user_look_id = {el.id} user = {el.user} removeSharedUser = {this.removeSharedUser}/>}.bind(this)) }
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
  isUserNew: function(){
    return this.props.user_look_id.toString().indexOf('new-look-user') != -1
  },
  render: function(){
    [removeUserMethod, user_look_id] = [this.toogleDestroy, this.props.user_look_id]
    if (this.isUserNew()) {
      [removeUserMethod, user_look_id] = [this.toogleDestroy, '']
    }
    return(
        <div id={`shared-user-id-${this.props.user.id }`}>
          <input id={`look_user_looks_attributes_${this.props.index}_id`} name={`look[user_looks_attributes][${this.props.index}][id]`} type='hidden' value={user_look_id}/>
          <input id={`look_user_looks_attributes_${this.props.index }_user_id`} name={`look[user_looks_attributes][${this.props.index}][user_id]`} type='hidden' value= { this.props.user.id}/>
          <input id={`look_user_looks_attributes_${this.props.index}__destroy`} name={`look[user_looks_attributes][${this.props.index}][_destroy]`} type='hidden' value={this.state.isDestroy}/>
          <div className = 'look-user-item'> <a onClick={ removeUserMethod } style = {{display: this.props.hide[this.state.isDestroy] }} title='Click to Remove'>{ this.props.user.email }</a></div>
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

UserField = React.createClass({
  getInitialState: function() {
    return {filtered_users: [], current_user: '', potential_users: this.props.potential_users, show_filtered: false}
  },
  filterUsers: function(e) {
    var filtered_users = [];
    var part_name = e.target.value;
    if (part_name.length > 1) {
      filtered_users = this.state.potential_users.filter(function (user) {
        if (user.email.indexOf(part_name) > -1) return user;
      });
      this.setState({show_filtered: true, filtered_users: filtered_users});
    }
    this.setState({current_user: part_name})
  },
  fillUserField: function(e){
    //this.setState({current_user: e.currentTarget.textContent});
    this.setState({current_user: ''});
    this.setState({filtered_users: []});
    this.props.addSharedUser(e)
  },
  clearUserField: function(e){
    this.setState({current_user: ''})
  },
  componentWillMount: function() {
    // add event listener for clicks
    document.addEventListener('click', this.handleOutsideClick, false);
  },
  componentWillUnmount: function() {
    // make sure you remove the listener when the component is destroyed
    document.removeEventListener('click', this.handleOutsideClick, false);
  },
  handleOutsideClick: function(e){
    if(!ReactDOM.findDOMNode(this).contains(e.target)) {
      this.setState({show_filtered: false})
    }
  },
  render: function(){
    var fillUserField = this.fillUserField
    return(
        <div className='potential-users-list'>
          <div className="text-input-wrapper" >
            <input id="user-autocomplete" type="text" value= {this.state.current_user} onChange={this.filterUsers}/>
            <span className="clear-input-btn" title="Clear" onClick={ this.clearUserField } style={{visibility: this.props.visibility[this.state.current_user.length === 0]}}>&times;</span>
          </div>
          {this.state.show_filtered &&
            <div className='filtered-users-list'>
              { this.state.filtered_users.map(function (user) {
                return (<FilteredUser key={user.id} user={user} fillUserField={fillUserField}/>)
              })}
              {!this.state.filtered_users.length && <span>No results</span>}
            </div>
          }
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
    return (
          <div className='look-user-item'><a onClick={this.props.fillUserField} data-user-id={this.props.user.id} title='Share'>{this.props.user.email}</a></div>
    )
  }
})
