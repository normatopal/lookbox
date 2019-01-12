ActiveAdmin.register Picture do

  index do
    column :id
    column :title
    column :description
    column 'User email' do |picture|
      link_to picture.user.email, admin_user_path(picture.user)
    end
    column 'Outer link' do |picture|
      link_to picture.link, picture.link
    end
    column :deleted_at
    actions
  end

  index as: :grid do |picture|
    link_to image_tag(picture.image.thumb.url), admin_picture_path(picture), title: picture.title
  end

end