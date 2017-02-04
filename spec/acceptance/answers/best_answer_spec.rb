require_relative '../acceptance_helper'

feature 'Best answer', %q{
  In order to the best answer
  As a author question
  I want to be able to note the best
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    context 'author question' do
      scenario 'see mark best link answer' do
        expect(page).to have_link 'Mark best'
      end

      scenario 'choose the best', js: true do
        click_on 'Mark best'
        expect(page).to have_content 'Answer best'
      end

      scenario 'choose another best', js: true do
        create(:answer, best: true, question: question)
        click_on 'Mark best'
        within ".answer-#{answer.id}" do
          expect(page).to have_content 'Answer best'
        end
      end

      scenario 'best answer onle one for question', js: true do
        answers = create_list(:answer, 5, question: question)
        another_answer = create(:answer, question: question)
        visit question_path(question)
        answers.each do |answer|
          within ".answer-#{answer.id}" do
            click_on 'Mark best'
          end
        end
        within ".answer-#{another_answer.id}" do
          click_on 'Mark best'
        end
        answers.each do |answer|
          within ".answer-#{answer.id}" do
            expect(page).to_not have_content 'Answer best'
          end
        end
        within ".answer-#{another_answer.id}" do
          expect(page).to have_content 'Answer best'
        end
      end
    end

    scenario 'not author question does not see link mark best' do
      another_question = create(:question)
      create_list(:answer, 5, question: another_question)
      visit question_path(another_question)
      expect(page).to_not have_link 'Mark best'
    end
  end

  scenario 'Non-authenticated user try to choose best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark best'
  end
end
