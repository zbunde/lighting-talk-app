require 'rails_helper'

feature 'Admin Lightning Talks' do
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


  scenario 'Admin can visit Admin lightning talks index' do
    talk = create_lightning_talk(user: @user, day_id: @day.id, name: 'Test Talk')
    visit admin_lightning_talks_path
    expect(page).to have_content 'Manage Talks'
    expect(page).to have_content 'Test Talk'
    expect(page).to have_content @user.username
  end

  scenario 'Admin can create a new lightning talk' do
    visit admin_lightning_talks_path

    click_on 'New Lightning Talk Admin'

    fill_in 'Talk Topic', with: 'Another Test Talk'
    select @day.talk_date, from: "Day"
    click_on 'Create Lightning Talk'

    expect(current_path).to eq(admin_lightning_talks_path)
    expect(page).to have_content @day.talk_date.strftime("%m/%d/%Y")
    expect(page).to have_content 'Another Test Talk'
  end

  scenario 'Admin can edit a lightning talk' do
    new_day = create_day(talk_date: Date.tomorrow)
    talk = create_lightning_talk(name: 'Test Talk')

    visit admin_lightning_talks_path
    expect(page).to have_content 'Test Talk'
    click_on 'Edit'

    fill_in 'Talk Topic', with: 'Changed the words'
    select new_day.talk_date, from: "Day"
    click_on 'Update Lightning Talk'

    expect(page).to have_content 'Changed the words'
    expect(page).to have_content new_day.talk_date.strftime("%m/%d/%Y")
    expect(page).to have_no_content 'Test Talk'
  end

  scenario 'Admin can delete a lightning talk' do
    talk = create_lightning_talk(name: 'Test Talk')

    visit admin_lightning_talks_path

    expect(page).to have_content 'Delete'
    expect(page).to have_content 'Test Talk'

    click_on 'Delete'

    expect(current_path).to eq(admin_lightning_talks_path)
    expect(page).to have_no_content 'Test Talk'
  end

  scenario 'Admin will not see a paginated lightning talk list 7 or less talks' do
    talk1 = create_lightning_talk(name: 'One')
    talk2 = create_lightning_talk(name: 'Two')
    talk3 = create_lightning_talk(name: 'Three')
    talk4 = create_lightning_talk(name: 'Four')
    talk5 = create_lightning_talk(name: 'Five')

    visit admin_lightning_talks_path

    expect(page).to have_content 'One'
    expect(page).to have_content 'Two'
    expect(page).to have_content 'Three'
    expect(page).to have_content 'Four'
    expect(page).to have_content 'Five'
    expect(page).to have_no_content 'Next'
    expect(page).to have_no_content 'Last'
  end

  scenario 'Admin will see a paginated lightning talk when there are more than 7 talks' do
    talk1 = create_lightning_talk(name: 'One')
    talk2 = create_lightning_talk(name: 'Two')
    talk3 = create_lightning_talk(name: 'Three')
    talk4 = create_lightning_talk(name: 'Four')
    talk5 = create_lightning_talk(name: 'Five')
    talk6 = create_lightning_talk(name: 'Six')
    talk7 = create_lightning_talk(name: 'Seven')
    talk8 = create_lightning_talk(name: 'Eight')
    talk9 = create_lightning_talk(name: 'Nine')

    visit admin_lightning_talks_path

    expect(page).to have_content 'One'
    expect(page).to have_content 'Two'
    expect(page).to have_content 'Three'
    expect(page).to have_content 'Four'
    expect(page).to have_content 'Five'
    expect(page).to have_content 'Six'
    expect(page).to have_content 'Seven'
    expect(page).to have_no_content 'Eight'
    expect(page).to have_no_content 'Nine'
    expect(page).to have_content 'Next'
    expect(page).to have_content 'Last'

    click_on 'Next'

    expect(page).to have_no_content 'One'
    expect(page).to have_no_content 'Two'
    expect(page).to have_no_content 'Three'
    expect(page).to have_no_content 'Four'
    expect(page).to have_no_content 'Five'
    expect(page).to have_no_content 'Six'
    expect(page).to have_no_content 'Seven'
    expect(page).to have_content 'Eight'
    expect(page).to have_content 'Nine'
    expect(page).to have_content 'Prev'
    expect(page).to have_content 'First'
  end

  scenario 'non admins cannot visit and are redirected' do
    @user.update!(admin: false)
    visit admin_lightning_talks_path
    expect(current_path).to eq root_path
    expect(page).to have_content 'You don\'t have permission to access that page'
  end

end
