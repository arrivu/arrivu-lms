module Elearning
  module AccountExtensions
    def self.included base
      base.class_eval do
        add_setting :no_students,
                    :root_only => false, :default => '100'
        add_setting :no_teachers,
                    :root_only => false, :default => '2'

        add_setting :no_admins,
                    :root_only => false, :default => '1'

        add_setting :no_courses,
                    :root_only => false, :default => '2'

        add_setting :unlimited,:boolean => true,
                    :root_only => false, :default => false

        add_setting :course_index_custom_design,:boolean => true,
                    :root_only => false, :default => false

      end
    end
  end
end