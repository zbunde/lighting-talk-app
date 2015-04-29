class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.date :talk_date
      t.integer :number_of_slots

      t.timestamps
    end
  end
end
