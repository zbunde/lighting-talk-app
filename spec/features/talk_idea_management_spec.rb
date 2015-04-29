require "spec_helper"

feature "creating talk ideas", js: true do
  before {
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
  scenario "adding a talk idea as a logged in user" do
    visit root_path

    expect(page).to have_content "Talk Ideas"
    expect(page).to_not have_button "New Talk Idea"

    click_on "Sign In"

    click_button "New Talk Idea"

    fill_in "Talk Idea", with: "How to make chocolate"

    click_on "Create Talk idea"

    expect(page).to have_content "How to make chocolate"
  end

  scenario "is invalid without a name" do
    visit root_path

    expect(page).to have_content "Talk Ideas"
    expect(page).to_not have_button "New Talk Idea"

    click_on "Sign In"

    click_button "New Talk Idea"

    click_on "Create Talk idea"
    expect(page).to have_content("That wasn't a great idea now was it?")
  end

end
