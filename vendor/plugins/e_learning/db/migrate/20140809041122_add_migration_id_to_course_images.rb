class AddMigrationIdToCourseImages < ActiveRecord::Migration
  tag :postdeploy
  def self.up
    add_column :course_images, :migration_id, :text
  end

  def self.down
    remove_column :course_images, :migration_id, :text
  end
end
