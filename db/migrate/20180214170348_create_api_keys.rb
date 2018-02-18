class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token, unique: true
      t.datetime :expires_at
      t.integer :user_setting_id
      t.boolean :active, default: 1

      t.timestamps null: false
    end
    add_index :api_keys, :access_token
    add_index :api_keys, :user_setting_id
  end
end
