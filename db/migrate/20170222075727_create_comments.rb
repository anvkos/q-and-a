class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :user, foreign_key: true
      t.integer :commentable_id
      t.string :commentable_type
      t.index [:commentable_id, :commentable_type]
      t.timestamps
    end
  end
end
