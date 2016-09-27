class AddPictureIdToLook < ActiveRecord::Migration
  def change
    add_column :looks, :picture_id, :integer
  end
end
