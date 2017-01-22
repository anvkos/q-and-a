require 'rails_helper'

feature 'User sign in', %q{
  In order to be able ask question
  As an User
  I want be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registred user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'non-registred user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wronguser@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end
