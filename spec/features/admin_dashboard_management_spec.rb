require 'rails_helper'

feature 'Admin Dashboard' do
  before {
    User.destroy_all
    @user = User.create!(username: "deitrick smells", email: "andrew@internet.com", auth_token: "abc123", admin: true)
    @day = Day.create!(talk_date: Date.today, number_of_slots: 5)

    # Used to test Github login, feel free to ignore
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
  }

  scenario 'User cannot visit admin dashboard if not an admin' do
    @user.update!(admin: false)
    visit root_path
    click_on 'Sign In'
    visit admin_path
    expect(page).to have_content 'You don\'t have permission to access that page'
    expect(current_path).to eq(root_path)
  end

  scenario 'Admin can visit admin dashboard if admin from admin button on nav' do
    visit root_path
    click_on 'Sign In'
    within '.nav.navbar-nav.navbar-right' do
      expect(page).to have_content 'Admin'
      click_on 'Admin'
    end
    expect(current_path).to eq(admin_path)
  end

  scenario 'Admin can visit Admin lightning talks index from dashboard' do
    visit root_path
    click_on 'Sign In'
    click_on 'Admin'
    expect(page).to have_content 'Manage Talks'
    click_on 'Manage Talks'
    expect(current_path).to eq(admin_lightning_talks_path)
  end

  scenario 'Admin can visit admin users index from dashboard' do
    visit root_path
    click_on 'Sign In'
    click_on 'Admin'
    expect(page).to have_content 'Manage Users'
    click_on 'Manage Users'
    expect(current_path).to eq(admin_users_path)
  end
end
