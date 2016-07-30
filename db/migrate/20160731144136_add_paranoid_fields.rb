class AddParanoidFields < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime
    add_column :pictures, :deleted_at, :datetime
  end
end
