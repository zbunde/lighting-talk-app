require 'spec_helper'

feature 'User can sign up for talk Idea' do
  before {
    user = create_user
    @day = create_day
    # Used to test Github login, feel free to ignore
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
       :provider => 'github',
       :uid => '123545',
       :info => {
         :nickname => user.username,
         :email => user.email,
       },
       credentials: OmniAuth::AuthHash.new(token: user.auth_token),
    })
  }

  scenario 'A logged in user can sign up for a talk idea' do
    TalkIdea.destroy_all
    create_talk_idea
    visit root_path
    click_on 'Sign In'
    expect(page).to have_content "Talk Ideas"
    expect(page).to have_content "Cool Talk"
    within '.list-group-item' do
      click_on 'Sign Up'
    end
    select @day.talk_date, from: "Day"
    click_on 'Create Lightning Talk'
    expect(page).to have_content "Thanks for signing up for a lightning talk!"
  end

  scenario 'A visitor can not sign up for a talk idea and is redirected with a flash message' do
    create_talk_idea
    visit root_path
    expect(page).to have_content "Talk Ideas"
    expect(page).to have_content "Cool Talk"
    within '.list-group-item' do
      click_on 'Sign Up'
    end
    expect(page).to have_content "Please login to see that page"
    expect(current_path).to eq(root_path)
  end
end
