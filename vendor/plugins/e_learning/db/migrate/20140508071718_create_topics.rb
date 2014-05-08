class CreateTopics < ActiveRecord::Migration
    tag :predeploy
    def self.up
      create_table :topics do |t|
        t.string :name
        t.string :color
        t.integer :account_id, :limit => 8
        t.integer :parent_topic_id, :limit => 8
        t.integer :root_topic_id, :limit => 8
        t.integer :parent_id, :limit => 8
        t.timestamps
      end

    end

    def self.down
      drop_table :topics
    end
  end
