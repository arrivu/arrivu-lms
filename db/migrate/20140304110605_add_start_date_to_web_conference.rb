class AddStartDateToWebConference < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :web_conferences, :start_date, :datetime
  end

  def self.down
    remove_column :web_conferences, :start_date
  end
end
