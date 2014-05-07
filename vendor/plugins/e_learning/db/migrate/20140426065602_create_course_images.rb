class CreateCourseImages < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :course_images do |t|
      t.integer :course_id,:limit => 8
      t.integer :account_id,:limit => 8
      t.integer :course_image_attachment_id,:limit => 8
      t.integer :course_back_ground_image_attachment_id,:limit => 8
      t.date :start_at
      t.date :end_at
      t.timestamps
    end
  end

  def self.down
    drop_table :course_images
  end
end
