class ChangeCoursePricingStartAtAndEndAtToTimeStamps < ActiveRecord::Migration
  tag :predeploy
  def self.up
    change_column :course_pricings, :start_at, :datetime
    change_column :course_pricings, :end_at, :datetime
  end

  def self.down
    change_column :course_pricings, :start_at, :date
    change_column :course_pricings, :end_at, :date
  end
end
