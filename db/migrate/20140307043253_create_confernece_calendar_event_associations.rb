class CreateConferneceCalendarEventAssociations < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :conference_calendar_event_associations do |t|
      t.integer :web_conference_id, :limit => 8
      t.integer :calendar_event_id, :limit => 8
      t.timestamps
    end
  end

  def self.down
    drop_table :conference_calendar_event_associations
  end
end
