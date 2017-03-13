class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :created_at, :updated_at
  has_many :attachments
  has_many :comments
end
