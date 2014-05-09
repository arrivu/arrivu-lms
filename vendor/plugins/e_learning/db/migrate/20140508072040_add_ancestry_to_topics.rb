class AddAncestryToTopics < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :topics, :ancestry, :string
    add_index  :topics, :ancestry
  end

  def self.down
    remove_column :topics, :ancestry
    remove_index  :topics, :ancestry
  end
end
