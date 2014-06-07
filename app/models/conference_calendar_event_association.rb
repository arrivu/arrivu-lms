class ConferenceCalendarEventAssociation < ActiveRecord::Base
  attr_accessible :web_conference_id,:calendar_event_id
  belongs_to :web_conference, :dependent => :destroy
  belongs_to :calendar_event
  validates_presence_of :web_conference_id , :calendar_event_id
end
