class AddSuperadminToUser < ActiveRecord::Migration
  def change
    add_column :users, :superadmin, :boolean, :null => false, :default => false
  end
end
