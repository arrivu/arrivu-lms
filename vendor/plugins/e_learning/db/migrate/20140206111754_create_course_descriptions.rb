class CreateCourseDescriptions < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :course_descriptions do |t|
      t.integer :course_id,:limit => 8
      t.integer :account_id,:limit => 8
      t.text :short_description
      t.text :long_description
      t.timestamps
    end
  end

  def self.down
    drop_table :course_descriptions
  end
end
