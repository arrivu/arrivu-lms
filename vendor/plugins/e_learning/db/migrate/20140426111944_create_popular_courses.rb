class CreatePopularCourses < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :popular_courses do |t|
      t.integer :course_id, :limit => 8
      t.integer :account_id, :limit => 8
      t.timestamps
    end
  end

  def self.down
    drop_table :popular_courses
  end
end
