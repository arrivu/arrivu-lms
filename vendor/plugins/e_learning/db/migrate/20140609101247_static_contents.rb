class StaticContents < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :static_contents do |t|
      t.integer :course_id,:limit => 8
      t.integer :account_id,:limit => 8
      t.text :content_type
      t.text :workflow_state
      t.text :page_desc
      t.timestamps
    end
  end

  def self.down
    drop_table :static_contents
  end
end
