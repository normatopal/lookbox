class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :title
      t.text :description
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
