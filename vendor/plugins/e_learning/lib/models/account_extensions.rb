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

        add_setting :account_statistics,:boolean => true,
                    :root_only => false, :default => true

        add_setting :account_index_page_custom_design, :boolean => true,
                    :root_only => false, :default => false

        after_create :create_stud_orientation_course

        def create_stud_orientation_course
          if self.root_account?
            courses = [{account_id: self.id,root_account_id: self.id, name:  "#{self.name.titleize} Student Orientation",start_at: Date.today,is_public: true,
                        course_code:  "#{self.name.titleize} Student Orientation",sis_source_id:  "#{self.name.titleize} Student Orientation",
                        workflow_state: 'available'}]


            @courses = []
            courses.each do |attributes|
              @courses <<  Course.create! do |t|
                t.account_id = attributes[:account_id]
                t.root_account_id = attributes[:root_account_id]
                t.name = attributes[:name]
                t.start_at = attributes[:start_at]
                t.is_public = attributes[:start_at]
                t.start_at = attributes[:is_public]
                t.course_code = attributes[:course_code]
                t.sis_source_id = attributes[:sis_source_id]
                t.workflow_state = attributes[:workflow_state]
              end
            end
            @course = @courses.first
            puts "Student orientation course created: #{@course.name}"
          end

        end

        def enroll_to_stud_orientation(user)
          @course = self.courses.active.find_by_sis_source_id("#{self.name.titleize} Student Orientation")
          if @course && !user.current_student_enrollment_course_ids.include?(@course.id)
            @course.enroll_user(user, 'TeacherEnrollment', {:enrollment_state => 'active'})
            puts "Site admin enrolled in a #{self.name} Student Orientation course"
          end
        end


      end
    end
  end
end