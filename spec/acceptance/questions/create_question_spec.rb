require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As on authenticated user
  I want to be able to ask questions
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text question'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  context 'mulitple sessions' do
    scenario "question appears on another user's page", js: true do
      title = 'Title new question'
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: title
        fill_in 'Body', with: 'text question'
        click_on 'Create'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content title
      end

      Capybara.using_session('guest') do
        expect(page).to have_content title
      end
    end
  end

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    expect(page).to_not have_content 'Ask question'
  end
end
