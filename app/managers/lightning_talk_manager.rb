class LightningTalkManager

  def self.build(lightning_talk)
    if lightning_talk.save
      day = lightning_talk.day
      day.update_attributes(number_of_slots: (day.number_of_slots - 1))
      [lightning_talk, true]
    else
      [lightning_talk, false]
    end
  end

  def self.update(lightning_talk, lightning_talk_params)
    old_day = lightning_talk.day
    if lightning_talk.update(lightning_talk_params)
      old_day.update_attributes(number_of_slots: (old_day.number_of_slots + 1))
      day = lightning_talk.day
      day.update_attributes(number_of_slots: (day.number_of_slots - 1))
      [lightning_talk, true]
    else
      [lightning_talk, false]
    end
  end

  def self.unbuild(lightning_talk)
    day = lightning_talk.day
    lightning_talk.destroy
    day.update_attributes(number_of_slots: (day.number_of_slots + 1))
  end
end
