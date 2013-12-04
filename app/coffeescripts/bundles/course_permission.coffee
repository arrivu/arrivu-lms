require [
  'jquery'
  'underscore'
  #'compiled/models/Role'
 # 'compiled/models/Account'
  'compiled/collections/CourseModuleCollection'
  'compiled/views/course_module_permissions/CourseModulePermissionIndexView'
  'compiled/views/course_module_permissions/ManageCourseModuleView'
], ($, _, CourseModuleCollection, CourseModulePermissionIndexView, ManageCourseModuleView) ->

  course_modules = new CourseModuleCollection ENV.COURSE_MODULES_FOR_ENROLLMENT

  enrolled_users = ENV.ENROLLED_COURSE_USERS

  courseModulePermissionIndexView = new CourseModulePermissionIndexView
    el: '#content'
    views:
      '#course_module_permission' : new ManageCourseModuleView
        collection: course_modules
        enrolled_users: enrolled_users

  courseModulePermissionIndexView.render()
  #$('#content').html(view.render().el)

