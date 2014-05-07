class AddCoursePricings < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :courses, :course_price, :float
  end

  def self.down
    remove_column :courses, :course_price
   end
end
