class CreateUserLooks < ActiveRecord::Migration
  def change
    create_table :user_looks do |t|
      t.integer :look_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
