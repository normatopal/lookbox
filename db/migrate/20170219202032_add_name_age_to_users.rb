class AddNameAgeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, unique: true
    add_column :users, :birth_date, :date
    add_index :users, :name
  end
end
