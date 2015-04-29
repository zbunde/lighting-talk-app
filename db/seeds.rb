p "Generating Dates"

def find_tuesdays_and_thursdays(date)
  if Day.all.count < 50
    if date.tuesday? || date.thursday?
      Day.create!(talk_date: date, number_of_slots: 5)
    end
    date = date.tomorrow
    find_tuesdays_and_thursdays(date)
  end
end

find_tuesdays_and_thursdays(Date.new(2015,02,03))
