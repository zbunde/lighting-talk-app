require "rails_helper"

feature "creating lightning talks" do
  before {
    User.destroy_all
    user = User.create!(username: "deitrick", email: "andrew@internet.com", auth_token: "abc123")
    @day = Day.create!(talk_date: Date.today, number_of_slots: 5)

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
  scenario "adding a lightning talk as a logged in user" do
    visit root_path

    click_on "Sign In"

    expect(page).to have_content "Sign Out"
    click_on "New Lightning Talk"

    fill_in "Talk Topic", with: "How to dance"
    select @day.talk_date, from: "Day"

    click_on "Create Lightning Talk"

    expect(page).to have_content "Thanks for signing up for a lightning talk!"
    expect(page).to have_content "deitrick"
    expect(page).to have_content "How to dance"
  end

  scenario "adding a lightning talk to a specific date" do
    visit root_path

    click_on "Sign In"

    click_on "Sign Up"
    expect(page).to have_content "New Lightning Talk For"

    fill_in "Talk Topic", with: "How to play the fiddle"

    click_on "Create Lightning Talk"

    expect(page).to have_content "Thanks for signing up for a lightning talk!"
    expect(page).to have_content "deitrick"
    expect(page).to have_content "How to play the fiddle"
  end
end
