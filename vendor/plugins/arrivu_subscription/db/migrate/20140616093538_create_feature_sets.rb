class CreateFeatureSets < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :feature_sets, :force => true do |t|
      t.integer :account_id, :null => false,:limit => 8
      t.string :name
      t.integer :no_students,:no_teachers,:no_admins,:no_courses,:storage
      t.boolean :unlimited ,default: false
    end
  end

  def self.down
    drop_table :feature_sets
  end
end
