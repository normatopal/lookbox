json.array!(@pictures) do |picture|
  json.extract! picture, :id, :title, :description, :user_id, :image
  json.url picture_url(picture, format: :json)
end
