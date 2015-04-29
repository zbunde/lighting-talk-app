require "rails_helper"

describe LightningTalkManager do
  describe ".build" do
    it "saves a valid lightning talk and updates the number of slots for a day" do
      day = create_day
      lightning_talk = LightningTalk.new(name: "How to dance", user_id: create_user.id, day_id: day.id)

      expect {
        expect {
        lightning_talk, success = LightningTalkManager.build(lightning_talk)
        expect(success).to eq true
        expect(lightning_talk.name).to eq "How to dance"
        }.to change{LightningTalk.count}.by(1)
      }.to change{day.reload.number_of_slots}.by(-1)
    end
  end

  describe ".unbuild" do
    it "destroys a lightning talk and updates the number of slots for a day" do
      day = create_day(number_of_slots: 4)
      lighting_talk = create_lightning_talk(day_id: day.id)

      expect {
        expect {
        LightningTalkManager.unbuild(lighting_talk)
        }.to change{LightningTalk.all.count}.by(-1)
      }.to change{day.reload.number_of_slots}.from(4).to(5)
    end
  end

  describe ".update" do
    it "saves the lightning talk and updates both dates that the talk is associated to" do
      day_one = create_day(talk_date: Date.today, number_of_slots: 4)
      day_two = create_day(talk_date: Date.tomorrow, number_of_slots: 5)
      lightning_talk = create_lightning_talk(day_id: day_one.id, name: "Never Give Up Never Surrender")

      expect {
        expect {
          expect {
            expect {
              LightningTalkManager.update(lightning_talk, {name: "Foobies", day_id: day_two.id})
            }.to change{lightning_talk.reload.name}.to("Foobies")
          }.to change{lightning_talk.reload.day_id}.to(day_two.id)
        }.to change{day_one.reload.number_of_slots}.from(4).to(5)
      }.to change{day_two.reload.number_of_slots}.from(5).to(4)
    end
  end
end
