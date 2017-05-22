class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.string :time_zone
      t.references :locale
      t.references :user
      t.timestamp
    end
  end
end
