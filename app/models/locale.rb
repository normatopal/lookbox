class Locale < ActiveRecord::Base

  def self.list
    @locales ||= self.where(visible: true)
  end

  def self.locales_set
    self.list.collect{|loc| [loc.name, loc.id]}
  end

  def self.default_locale
    self.list.find_by_locale(I18n.default_locale.to_s)
  end

end
