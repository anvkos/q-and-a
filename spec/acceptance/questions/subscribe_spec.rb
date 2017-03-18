require_relative '../acceptance_helper'

feature 'Subscribe question', %q{
  In order to be able receive notifications of new answers
  As an authenticated user
  I want to be able to subscribe to a question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    context 'Not author question' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'Sees a link to subscribe to question' do
        expect(page).to have_link 'Subscribe'
        expect(page).to_not have_link 'Unsubscribe'
      end

      scenario 'subscribe question', js: true do
        click_on 'Subscribe'
        expect(page).to_not have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end

      scenario 'unsubscribe question', js: true do
        click_on 'Subscribe'
        expect(page).to_not have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'

        click_on 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
        expect(page).to_not have_link 'Unsubscribe'
      end
    end

    context 'author question', js: true do
      scenario 'unsubscribe', js: true do
        pending
        create(:question, user: user)
        visit question_path(question)
        expect(page).to_not have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'

        click_on 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
        expect(page).to_not have_link 'Unsubscribe'
      end
    end
  end

  scenario 'Non-authenticated user tries subscribe' do
    visit question_path(question)
    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end
end
