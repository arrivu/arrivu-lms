desc "Create student orientation course"
namespace :db do
  task create_student_orientation: :environment do
    account = Account.default
    @course = account.courses.active.find_by_sis_source_id("#{account.name.titleize} Student Orientation")
    if @course
      puts "Student orientation course found"
    else
      puts "Creating student orientation course"

      puts "Got account: #{account.name}"

      courses = [{account_id: account.id,root_account_id: account.id, name: "#{account.name.titleize} Student Orientation",start_at: Date.today,is_public: true,
                                      course_code: "#{account.name.titleize} Student Orientation",sis_source_id: "#{account.name.titleize} Student Orientation",
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
      puts "Course created: #{@course.name}"
    end

    site_admin_ac_admin_user = Account.site_admin.account_users.first
    puts "Got site admin: #{site_admin_ac_admin_user.user.name}"
    if @course && !site_admin_ac_admin_user.user.current_student_enrollment_course_ids.include?(@course.id)
      @course.enroll_user(site_admin_ac_admin_user.user, 'TeacherEnrollment', {:enrollment_state => 'active'})
      puts "Site admin enrolled"
    end
    users = Account.default.all_users(9999).active
    puts "Got #{users.size} ,users"
    users.each do |user|
      puts "#{user.name} ,user"
      if @course && user && !user.current_student_enrollment_course_ids.include?(@course.id)
        @course.enroll_user(user, 'StudentEnrollment', {:enrollment_state => 'active'})
        puts "#{user.name}, enrolled."
      end
    end


  end
end
