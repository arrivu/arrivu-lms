class LearnersReview < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :learners_reviews do |t|
      t.integer :account_id, :limit => 8
      t.string :user_name
      t.string :message
      t.integer :user_id, :limit => 8
      t.timestamps
    end
  end

  def self.down
    drop_table :learners_reviews
  end
end
