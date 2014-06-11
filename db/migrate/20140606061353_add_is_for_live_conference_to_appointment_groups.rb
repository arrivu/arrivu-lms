class AddIsForLiveConferenceToAppointmentGroups < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :appointment_groups, :is_for_live_conference, :boolean ,default: false
    add_column :appointment_groups, :live_conference_type, :text
  end

  def self.down
    remove_column :appointment_groups, :is_for_live_conference
    remove_column :appointment_groups, :live_conference_type
  end
end
