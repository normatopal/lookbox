class AddTransformationToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :transformation_params, :text
  end
end
