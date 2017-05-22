class CreateLocales < ActiveRecord::Migration
  def up
    create_table :locales do |t|
      t.string :locale
      t.string :name
      t.boolean :visible, default: true
      t.timestamps
    end

    add_index :locales, :locale
    add_index :locales, :name

    locales = [
            {locale: 'en', name: 'English'},
            {locale: 'de', name: 'Deutsch'},
            {locale: 'ru', name: 'Русский'},
            {locale: 'ua', name: 'Українська'},
            {locale: 'es', name: 'Español'}
    ]

    locales.each do |locale|
      execute "insert into locales( locale, name, created_at, updated_at) values( '#{locale[:locale]}', '#{locale[:name]}', NOW(), NOW())"
    end
  end

  def down
    drop_table :locales
  end
end
