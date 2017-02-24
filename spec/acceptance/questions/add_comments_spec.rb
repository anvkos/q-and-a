require_relative '../acceptance_helper'

feature 'Add comment to questions', %q{
  In order to clarify question
  As an authenticated user
  I want to be able comment on question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'creates comment', js: true do
      sign_in(user)
      visit question_path(question)
      comment_text = 'some text commentary'
      fill_in 'Content', with: comment_text
      click_on 'Add new comment'
      within '.comments' do
        expect(page).to have_content comment_text
      end
      expect(current_path).to eq question_path(question)
    end

    context 'multiple sessions' do
      scenario "comment appears on another user's page", js: true do
        comment_text = 'My comment text'
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end
        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          fill_in 'Content', with: comment_text
          click_on 'Add new comment'
          within '.comments' do
            expect(page).to have_content comment_text
          end
        end
        Capybara.using_session('guest') do
          within '.comments' do
            expect(page).to have_content comment_text
          end
        end
      end
    end
  end

  scenario 'Non-authenticated user tries add comment' do
    visit question_path(question)
    expect(page).not_to have_selector('#comment_content')
  end
end
