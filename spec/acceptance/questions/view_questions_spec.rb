require 'rails_helper'

feature 'View questions', %q{
  In order to read the text of the question
  As a user
  I want to be able to see the issue
} do

  scenario 'User view questions' do
    questions = create_list(:question, 2)
    visit questions_path
    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.second.title
  end

  scenario 'User view question and answers to it' do
    question = create(:question)
    answers = create_list(:answer, 2, question: question)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers.first.body
    expect(page).to have_content answers.second.body
  end
end
