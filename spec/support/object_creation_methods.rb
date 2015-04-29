def create_lightning_talk(options = {})
  defaults = {
    name: "Git Duet",
    user_id: create_user.id,
    day_id: create_day.id
  }

  LightningTalk.create!(defaults.merge(options))
end

def create_day(options = {})
  defaults = {
    talk_date: Date.today,
    number_of_slots: 5
  }

  Day.create!(defaults.merge(options))
end

def create_user(options = {})
  defaults = {
    username: "george_bush#{rand(10000)+1}",
    email: "george#{rand(10000)}@internet.com",
    auth_token: "abc123",
    admin: false
  }

  User.create!(defaults.merge(options))
end

def create_talk_idea(options = {})
  defaults = {
    name: "Cool Talk",
    user_id: 1
  }

  TalkIdea.create!(defaults.merge(options))
end
