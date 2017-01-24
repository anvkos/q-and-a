require 'rails_helper'

feature 'Create answer', %q{
  In order to offer an answer
  As a user
  I want to be able to write the answer
} do

  given (:question) { create(:question) }

  scenario 'User create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'My answer text'
    click_on 'Add new answer'
    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'My answer text'
    expect(current_path).to eq question_path(question)
  end

  scenario 'User create answer with invalid attributes' do
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Add new answer'
    expect(page).to have_content "Not the correct answer data"
  end

end
