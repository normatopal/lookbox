class PictureDecorator < Draper::Decorator
  delegate_all

  def categories_set
    object.user.categories.collect { |cat| ["#{'-' * cat.level} #{cat.name}", cat.id] }
  end

end