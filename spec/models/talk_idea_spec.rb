require "rails_helper"

describe TalkIdea do
  describe "validations" do
    let(:valid_attributes) {
      {
        name: "How to build a cabin by the sea"
      }
    }

    it "is valid" do
      talk_idea = TalkIdea.new(valid_attributes)

      expect(talk_idea.valid?).to eq true
    end

    it "is invalid without a name" do
      valid_attributes.delete(:name)
      talk_idea = TalkIdea.new(valid_attributes)

      expect(talk_idea.valid?).to eq false
      expect(talk_idea.errors[:name]).to eq ["can't be blank"]
    end
  end
end

describe User do
  describe "validations" do
    it "is valid" do
      user = create_user
      expect(user).to be_valid
    end

    it "is invalid without a username" do
      user = User.create(username: nil)
      expect(user).to be_invalid
    end

    it "is invalid without a email" do
      user = User.create(email: nil)
      expect(user).to be_invalid
    end

    it "is invalid without a unique username" do
      user = User.create(username: "same_username", email: "email@example.com", auth_token: "pending")
      user2 = User.create(username: "same_username", email: "different_email@example.com", auth_token: "pending")
      expect(user2).to be_invalid
    end

    it "is invalid without a unique email" do
      user = User.create(username: "username", email: "same_email@example.com", auth_token: "pending")
      user2 = User.create(username: "different_username", email: "same_email@example.com", auth_token: "pending")
      expect(user2).to be_invalid
    end
  end
end
