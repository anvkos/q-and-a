require_relative '../acceptance_helper'

feature 'Sign in OAuth', %q{
  In order to be able to sign in through account social network
  As non-authenticated user
  I want to be able to sign in through my social network account
} do
  context 'provider received email' do
    scenario 'sign in through facebook' do
      received_email = 'email@example.test'
      OmniAuth.config.add_mock(:facebook, uid: '123456', info: { email: received_email })
      visit new_user_session_path
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'For complete the registration your need to confirm email!'
      expect(page).to have_content 'Confirm your email'

      fill_in 'Email', with: received_email
      click_on 'Confirm email'
      open_email(received_email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(current_path).to eq root_path
    end
  end

  context 'provider not received email' do
    scenario 'sign in through twitter' do
      email = 'email@example.test'
      OmniAuth.config.add_mock(:twitter, uid: '123456')
      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'For complete the registration your need to confirm email!'
      expect(page).to have_content 'Confirm your email'

      fill_in 'Email', with: email
      click_on 'Confirm email'
      open_email(email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'

      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end
  end

  scenario 'email not confirmed' do
    email = 'email@example.test'
    OmniAuth.config.add_mock(:twitter, uid: '123456')
    visit new_user_session_path
    click_on 'Sign in with Twitter'

    fill_in 'Email', with: email
    click_on 'Confirm email'

    visit new_user_session_path
    click_on 'Sign in with Twitter'
    expect(page).to have_content 'For complete the registration your need to confirm email!'
    expect(page).to have_content 'Confirm your email'
  end

  scenario 'confirmed email is already in use' do
    user = create(:user)
    OmniAuth.config.add_mock(:twitter, uid: '123456')
    visit new_user_session_path
    click_on 'Sign in with Twitter'
    fill_in 'Email', with: user.email
    click_on 'Confirm email'
    expect(page).to have_content 'Email already in use!'
  end
end
