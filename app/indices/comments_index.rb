ThinkingSphinx::Index.define :comment, with: :active_record do
  # fields
  indexes content

  # attributes
  has user_id, created_at, updated_at
end
