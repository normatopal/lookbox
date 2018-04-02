class AddLinkFieldToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :link, :string
  end
end
