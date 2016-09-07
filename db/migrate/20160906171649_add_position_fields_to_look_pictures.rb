class AddPositionFieldsToLookPictures < ActiveRecord::Migration
  def change
    add_column :look_pictures, :position_top, :integer
    add_column :look_pictures, :position_left, :integer
  end
end
