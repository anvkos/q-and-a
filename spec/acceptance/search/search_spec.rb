require_relative '../acceptance_helper'

feature 'Search', %q{
  In order to find an interesting question, answer, comment, user
  As a user
  I want to be able to search
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }
  given!(:comment) { create(:comment, commentable: question) }
  given!(:comment_answer) { create(:comment, commentable: answer) }
  given!(:questions) { create_list(:question, 10) }

  before do
    index
    visit search_path
  end

  scenario 'search in questions', sphinx: true do
    fill_in 'q', with: question.title
    check 'scope_question'
    click_on 'Search'
    within '.search-results' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'search in answers', sphinx: true do
    fill_in 'q', with: answer.body
    check 'scope_answer'
    click_on 'Search'
    within '.search-results' do
      expect(page).to have_content answer.question.title
      expect(page).to have_content answer.body
    end
  end

  context 'search in comments' do
    scenario 'to question', sphinx: true do
      fill_in 'q', with: comment.content
      check 'scope_comment'
      click_on 'Search'
      within '.search-results' do
        expect(page).to have_content comment.content
        expect(page).to have_content question.title
      end
    end

    scenario 'to answer', sphinx: true do
      fill_in 'q', with: comment_answer.content
      check 'scope_comment'
      click_on 'Search'
      within '.search-results' do
        expect(page).to have_content comment_answer.content
        expect(page).to have_content answer.question.title
      end
    end
  end

  scenario 'search in users', sphinx: true do
    fill_in 'q', with: user.email
    check 'scope_user'
    click_on 'Search'
    within '.search-results' do
      expect(page).to have_content user.email
    end
  end

  scenario 'search all', sphinx: true do
    fill_in 'q', with: 'text'
    check 'scope_all'
    click_on 'Search'
    within '.search-results' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content comment.content
      expect(page).to have_content answer.body
      expect(page).to have_content answer.question.title
    end
  end

  scenario 'nothing found', sphinx: true do
    fill_in 'q', with: 'Some unimaginable text'
    check 'scope_all'
    click_on 'Search'
    within '.search-results' do
      expect(page).to have_content 'Nothing found'
    end
  end

  scenario 'pagination', sphinx: true do
    fill_in 'q', with: 'Question'
    check 'scope_all'
    click_on 'Search'
    within '.search-results' do
      expect(page).to have_selector('.item', 5)
    end
  end
end
