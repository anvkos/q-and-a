require_relative '../acceptance_helper'

feature 'Delete files of answer', %q{
  In order to delete the downloaded file by mistake
  As the author of the answer
  I want to be able to delete attached file
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  before do
    @expected_file_name = 'spec_helper.rb'
    @expected_href = "/uploads/attachment/file/1/#{@expected_file_name}"
  end

  describe 'Authenticated user' do

    before do
      sign_in(user)
    end

    context 'Author' do
      scenario 'try delete attached file', js: true do
        visit question_path(question)
        expect(page).to have_link @expected_file_name, href: @expected_href
        click_on 'Delete file'
        expect(page).to_not have_link @expected_file_name, href: @expected_href
      end
    end

    context 'not author' do
      scenario 'try delete attached file', js: true do
        another_question = create(:question)
        another_answer = create(:answer, question: another_question)
        create(:attachment, attachable: another_answer)
        visit question_path(another_question)
        expect(page).to have_link @expected_file_name, href: '/uploads/attachment/file/2/spec_helper.rb'
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  scenario 'Non-authenticated user try delete file', js: true do
    visit question_path(question)
    expect(page).to have_link @expected_file_name, href: @expected_href
    expect(page).to_not have_link 'Delete file'
  end
end
