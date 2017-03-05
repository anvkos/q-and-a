require_relative '../acceptance_helper'

feature 'User sign up', %q{
  In order to be able to ask questions
  As a guest
  I want to be able to register in the system
} do

  scenario 'Guest user try to sign up' do
    visit root_path
    click_link 'Sign up'
    registration_email = 'reguser@test.com'
    fill_in 'Email', with: registration_email
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address'
    expect(page).to have_content 'Please follow the link to activate your account.'

    open_email(registration_email)
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
    expect(current_path).to eq new_user_session_path
  end
end
