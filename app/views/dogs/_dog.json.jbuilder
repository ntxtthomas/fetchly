json.extract! dog, :id, :name, :breed, :age, :weight, :owner_id, :created_at, :updated_at
json.url dog_url(dog, format: :json)
