require_relative '../acceptance_helper'

feature 'Create answer', %q{
  In order to offer an answer
  As a user
  I want to be able to write the answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)
    answer_text = 'My answer text'
    fill_in 'Body', with: answer_text
    click_on 'Add new answer'
    within '.answers' do
      expect(page).to have_content answer_text
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user create answer with invalid attributes', js: true  do
    sign_in(user)
    visit question_path(question)
    answer_text = 'text567'
    fill_in 'Body', with: answer_text
    click_on 'Add new answer'
    expect(page).not_to have_content answer_text
  end

  scenario 'Non-authenticated user try to creates qiestion', js: true  do
    visit question_path(question)

    expect(page).not_to have_selector('#answer_body')
  end
end
