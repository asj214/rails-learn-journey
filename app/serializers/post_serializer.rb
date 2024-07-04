class PostSerializer < ActiveModel::Serializer
  attributes :id, :user, :title, :body, :created_at, :updated_at, :deleted_at
  belongs_to :user
end
