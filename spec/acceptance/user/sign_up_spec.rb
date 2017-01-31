require_relative '../acceptance_helper'

feature 'User sign up', %q{
  In order to be able to ask questions
  As a guest
  I want to be able to register in the system
} do

  scenario 'Guest user try to sign up' do
    visit root_path
    click_link 'Sign up'
    fill_in 'Email', with: 'reguser@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end
end
