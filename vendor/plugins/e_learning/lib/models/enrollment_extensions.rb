module Elearning
  module EnrollmentExtensions
    def self.included base
      base.class_eval do

        scope :all_teacher,
              includes(:course).
                  where("(enrollments.type = 'TeacherEnrollment'
              AND enrollments.workflow_state IN ('invited', 'active', 'completed')
              AND courses.workflow_state IN ('available', 'completed')) OR
              (enrollments.workflow_state = 'active'
              AND courses.workflow_state != 'deleted')")


      end
    end
  end
end