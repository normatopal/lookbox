class AddApprovedFieldToUserLooks < ActiveRecord::Migration
  def change
    add_column :user_looks, :is_approved, :boolean, default: false
  end
end
