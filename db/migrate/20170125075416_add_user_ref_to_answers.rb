class AddUserRefToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_reference :answers, :user, foreign_key: true
  end
end
