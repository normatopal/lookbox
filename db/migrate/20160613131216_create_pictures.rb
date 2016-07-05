class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :title
      t.text :description
      t.string :user_id
      t.string :bigint

      t.timestamps null: false
    end
  end
end
