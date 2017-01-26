require 'rails_helper'

feature 'View questions', %q{
  In order to read the text of the question
  As a user
  I want to be able to see the issue
} do
  scenario 'User view questions' do
    questions = create_list(:question, 5)
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'User view question and answers to it' do
    question = create(:question)
    answers = create_list(:answer, 5, question: question)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
