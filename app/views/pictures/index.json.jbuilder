json.array!(@pictures) do |picture|
  json.extract! picture, :id, :title, :description, :user_id, :bigint
  json.url picture_url(picture, format: :json)
end
