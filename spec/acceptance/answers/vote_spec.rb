require_relative '../acceptance_helper'

feature 'Vote answer', %q{
  In order to be able to vote "yes"/"against" answer
  As an authenticated user
  I want to be able to vote for answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    context 'Not author answer' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'see links for votes to answer', js: true do
        within '.answers' do
          expect(page).to have_link 'Vote Up'
          expect(page).to have_link 'Vote Down'
          expect(page).to_not have_link 'Cancel vote'
        end
      end

      scenario 'vote up', js: true do
        within '.answers' do
          click_on 'Vote Up'
          expect(page).to have_text 'Rating:1'
          expect(page).to_not have_link 'Vote Up'
          expect(page).to_not have_link 'Vote Down'
          expect(page).to have_link 'Cancel vote'
        end
      end

      scenario 'vote down', js: true do
        within '.answers' do
          click_on 'Vote Down'
          expect(page).to have_text 'Rating:-1'
          expect(page).to_not have_link 'Vote Up'
          expect(page).to_not have_link 'Vote Down'
          expect(page).to have_link 'Cancel vote'
        end
      end

      scenario 'vote cancel', js: true do
        create(:vote, votable: answer, user: user)
        visit question_path(question)
        within '.answers' do
          expect(page).to have_text 'Rating:1'
          expect(page).to_not have_link 'Vote Up'
          expect(page).to_not have_link 'Vote Down'
          expect(page).to have_link 'Cancel vote'

          click_on 'Cancel vote'
          expect(page).to have_text 'Rating:0'
          expect(page).to have_link 'Vote Up'
          expect(page).to have_link 'Vote Down'
          expect(page).to_not have_link 'Cancel vote'
        end
      end
    end

    scenario 'author answer tries to vote', js: true do
      sign_in(answer.user)
      visit question_path(question)
      within '.answers' do
        expect(page).to have_text 'Rating:0'
        expect(page).to_not have_link 'Vote Up'
        expect(page).to_not have_link 'Vote Down'
      end
    end
  end

  scenario 'Non-authenticated user tries', js: true do
    visit question_path(question)
    within '.answers' do
      expect(page).to have_text 'Rating:0'
      expect(page).to_not have_link 'Vote Up'
      expect(page).to_not have_link 'Vote Down'
    end
  end
end
