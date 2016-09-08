class CreateLookPictures < ActiveRecord::Migration
  def change
    create_table :look_pictures do |t|
      t.integer :look_id
      t.integer :picture_id
      t.integer :position_top, default: 0
      t.integer :position_left, default: 0
    end

    add_index :look_pictures, [:look_id, :picture_id]
  end
end
