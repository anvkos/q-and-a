require_relative '../acceptance_helper'

feature 'Add comment to answer', %q{
  In order to clarify answer
  As an authenticated user
  I want to be able comment on asnwer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    scenario 'creates comment', js: true do
      sign_in(user)
      visit question_path(question)
      comment_text = 'some text commentary'
      within '.answers .comments' do
        fill_in 'Content', with: comment_text
        click_on 'Add new comment'
        expect(page).to have_content comment_text
      end
      expect(current_path).to eq question_path(question)
    end
  end

  scenario 'Non-authenticated user tries add comment' do
    visit question_path(question)
    expect(page).not_to have_selector('#comment_content')
  end
end
