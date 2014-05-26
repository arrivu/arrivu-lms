#require [
#  'jquery'
#  'compiled/views/CourseComments/CourseCommentsCollectionView'
#  'compiled/collections/CourseCommentsCollection'
#], ($,CourseCommentsCollectionView,CourseCommentsCollection) ->
#
#  class CourseComments extends Backbone.View
#
#    courseCommentCollection = new CourseCommentsCollection
#
#    courseCommentCollectionView = new CourseCommentsCollectionView
#      collection: courseCommentCollection
#
#    $("#comments_review").click ->
#      courseCommentCollection.url = "/api/v1/libraries/"+ENV.review_course_id+"/course_reviews"
#      $("#content").disableWhileLoading courseCommentCollection.fetch(
#        success:->
#          courseCommentCollectionView.render
#      )

