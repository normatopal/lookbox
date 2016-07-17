class CategoryPictures < ActiveRecord::Migration
  def self.up
    create_table :category_pictures do |t|
      t.integer :category_id
      t.integer :picture_id

      t.timestamps null: false
    end

    add_index :category_pictures, [:category_id, :picture_id]
  end

  def self.down
    drop_table :category_pictures
  end
end
