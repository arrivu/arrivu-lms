class AddMigrationIdToCourseDescriptions < ActiveRecord::Migration
  tag :postdeploy
  def self.up
    add_column :course_descriptions, :migration_id, :text
  end

  def self.down
    remove_column :course_descriptions, :migration_id
  end
end
