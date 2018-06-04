CategoriesSelect = React.createClass({
  getInitialState(){
    return{
      selected_categories: JSON.parse(this.props.selected_categories),
      search_element: this.props.search_element
    }
  },
  getDefaultProps() {
    return{
      selected_categories: '',
      search_element: '#q_category_search'
    }
  },
  componentWillMount(){
    this.createCategoriesSelectFilter()
  },
  createCategoriesSelectFilter(){
    $(this.state.search_element).select2({
      theme: "bootstrap",
      placeholder: 'All',
      maximumSelectionLength: 4
    })
    this.reloadSelectedCategories()
  },
  reloadSelectedCategories(){
    if (this.state.selected_categories != null && this.state.selected_categories != '')
      $(this.state.search_element).val(this.state.selected_categories).trigger("change")
  },
  render(){
    return(<div></div>)
  }
})