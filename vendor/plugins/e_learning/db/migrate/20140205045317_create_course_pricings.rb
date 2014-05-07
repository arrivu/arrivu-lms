class CreateCoursePricings < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :course_pricings do |t|
      t.integer :course_id,:limit => 8
      t.float :price,:default => 0
      t.date :start_at
      t.date :end_at
      t.integer :account_id,:limit => 8
      t.timestamps
    end
  end

  def self.down
    drop_table :course_pricings
  end
end
