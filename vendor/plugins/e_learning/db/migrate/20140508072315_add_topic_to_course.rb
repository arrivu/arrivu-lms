class AddTopicToCourse < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :courses, :topic_name, :text
    add_column :courses, :topic_id, :integer, :limit => 8
  end

  def self.down
    remove_column :courses, :topic_name
    remove_column :courses, :topic_id

  end
end
