require 'rails_helper'

feature 'Admin Users' do

  before {
    User.destroy_all
    @user = create_user(admin: true)
    @day = create_day
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
       :provider => 'github',
       :uid => '123545',
       :info => {
         :nickname => @user.username,
         :email => @user.email,
       },
       credentials: OmniAuth::AuthHash.new(token: @user.auth_token),
    })
    visit root_path
    click_on 'Sign In'
  }

  scenario 'Admin can visit users page for admin onlys and see users' do
    visit admin_users_path
    expect(current_path).to eq admin_users_path
    expect(page).to have_content 'Manage Users'
  end

  scenario 'A non admin is redirected if trying to visit this path' do
    @user.update!(admin: false)
    visit admin_users_path
    expect(current_path).to eq root_path
    expect(page).to have_content 'You don\'t have permission to access that page'
  end

  scenario 'An admin can delete a user' do
    user = create_user
    visit admin_users_path
    expect(page).to have_content user.username
    expect(page).to have_content 'Delete'
    click_on 'Delete'
    expect(page).to have_content 'You have removed a user'
  end
end
