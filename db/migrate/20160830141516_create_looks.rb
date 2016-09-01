class CreateLooks < ActiveRecord::Migration
  def change
    create_table :looks do |t|
      t.string :name
      t.text :description
      t.integer :user_id

      t.timestamps null: false
      t.datetime :deleted_at
    end
  end
end
