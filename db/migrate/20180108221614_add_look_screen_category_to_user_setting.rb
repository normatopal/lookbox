class AddLookScreenCategoryToUserSetting < ActiveRecord::Migration
  def change
    add_column :user_settings, :look_screen_category_id, :integer
  end
end
