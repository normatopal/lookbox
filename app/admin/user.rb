ActiveAdmin.register User do

  filter :email
  filter :id, as: :numeric
  filter :name
  filter :superadmin, as: :check_boxes

  index do
    column :id
    column :email
    column :name
    column :birth_date
    column :encrypted_password
    column :superadmin
    column :deleted_at
    actions
  end

  index as: :grid do |user|
    link_to user.email, edit_admin_user_path(user)
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :superadmin, :label => "Super Administrator"
    end
    f.actions
  end

  create_or_edit = Proc.new {
    @user            = User.find_or_create_by_id(params[:id])
    @user.superadmin = params[:user][:superadmin]
    @user.attributes = params[:user].delete_if do |k, v|
      (k == "superadmin") ||
              (["password", "password_confirmation"].include?(k) && v.empty? && !@user.new_record?)
    end
    if @user.save
      redirect_to :action => :show, :id => @user.id
    else
      render active_admin_template((@user.new_record? ? 'new' : 'edit') + '.html.erb')
    end
  }
  member_action :create, :method => :post, &create_or_edit
  member_action :update, :method => :put, &create_or_edit

end