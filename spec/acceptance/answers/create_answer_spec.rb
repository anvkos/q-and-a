require 'rails_helper'

feature 'Create answer', %q{
  In order to offer an answer
  As a user
  I want to be able to write the answer
} do

  given(:user) { create(:user) }
  given (:question) { create(:question) }

  scenario 'Authenticated user create answer' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'My answer text'
    click_on 'Add new answer'
    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'My answer text'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user create answer with invalid attributes' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Add new answer'
    expect(page).to have_content "Not the correct answer data"
  end

  scenario 'Non-authenticated user try to creates qiestion' do
    visit question_path(question)
    fill_in 'Body', with: 'My answer text'
    click_on 'Add new answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
