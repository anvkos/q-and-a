ThinkingSphinx::Index.define :answer, with: :active_record do
  # fields
  indexes body

  # attributes
  has user_id, created_at, updated_at
end
