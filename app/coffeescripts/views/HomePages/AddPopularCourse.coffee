define [
  'jquery'
  'i18n!home_pages'
  'str/htmlEscape'
  'jst/HomePages/AddPopularCourse'
  'compiled/models/PopularCourse'
  'compiled/collections/PopularCoursesCollection'
  'compiled/views/HomePages/AccountCourseCollectionView'
  'compiled/views/HomePages/PopularCourseCollectionView'
  'compiled/views/ValidatedFormView'
  'jquery.disableWhileLoading'
  'jqueryui/jquery.jcontent.0.8',
  'jqueryui/jquery.easing.1.3'
], ($,I18n,htmlEscape, template,PopularCoure,PopularCoursesCollection,AccountCourseCollectionView,PopularCourseCollectionView,
    ValidatedFormView) ->

  class AddPopularCourse extends ValidatedFormView
    template: template
    tagname:'form'
    id:'add_popular_course_form'

    events:
     'click .popular_course_item': 'addpopularcourse'

    className: 'validated-form-view form-horizontal bootstrap-form'

    afterRender: ->
      super
      @$el.dialog
        title: 'Add Popular Course'
        width:  1200
        height: 600
        disableWhileLoading: true
        position: top
        close: => @$el.remove()
      @showallAccountCourses()

    showPopularCourseonIndexPage: =>
      popularCourseCollection = new PopularCoursesCollection
      popularCourseCollectionView = new PopularCourseCollectionView
        collection: popularCourseCollection
        el: '#popular_course_div'
      popularCourseCollection.setParam('source', "popular")
      popularCourseCollectionView.collection.fetch(
        success:->
          if $("#popular_course_div").find("#popular_course_on_index_page").length == 0
            $("#popular_course_div").css('background-image','url()')
            $("#popular_course_banner").hide()
            $("#more_courses").hide()
            $("#popular_course_paginating").hide()
      )
      popularCourseCollectionView.render()

    showallAccountCourses: =>
      popularCourseCollection = new PopularCoursesCollection
      accountCourseCollectionView = new AccountCourseCollectionView
        collection: popularCourseCollection
        el: '#all_courses'
      popularCourseCollection.setParam('per_page', 3)
      popularCourseCollection.setParam('source', "account_courses")
      accountCourseCollectionView.collection.fetch()
      accountCourseCollectionView.render()

    onSaveFail: (xhr) =>
      super
      message = xhr.responseText
      @$el.prepend("<div class='alert alert-error'>#{message}</span>")

    onSuccess = (event) ->
      $.flashMessage(htmlEscape(I18n.t('popular_courses_created_message', " Popular Courses Added Suceessfully!")))

    onSuccessdelete = (event) ->
      $.flashMessage(htmlEscape(I18n.t('popular_courses_deleted_message', " Popular Courses Deleted Suceessfully!")))

    onError = => @onSaveFail()

    addpopularcourse:(event)->
      popularcourse = @$(event.currentTarget).closest('.popular_course_item').data('view')
      popularcourseitem = popularcourse.model
      if this.$(event.currentTarget.firstElementChild).attr('id') == "is_a_popular_course"
        popular_id = this.$(event.currentTarget.firstElementChild).attr('data-id')
        id = popular_id
      else
        id = popularcourseitem.id
      data =
        popular_course_data:
          popular_course_id: id
          account_id: ENV.account_id
      if this.$(event.currentTarget.firstElementChild).attr('id') == "is_a_popular_course"
        popular_id = this.$(event.currentTarget.firstElementChild).attr('data-id')
        deletemsg = "Are you sure want to remove this Course from Popular Courses?"
        dialog = $("<div>#{deletemsg}</div>").dialog
          modal: true,
          resizable: false
          title: I18n.t('delete', 'Delete popular Course')
          buttons: [
            text: 'Cancel'
            click: => dialog.dialog 'close'
          ,
            text: 'Delete'
            click: =>
              url = "api/v1/accounts/"+ENV.account_id+"/popular_courses/"+ id
              @$el.disableWhileLoading($.ajaxJSON url, 'DELETE',data, onSuccessdelete,onError)
              dialog.dialog 'close'
              if $("#popular_course_div").find("#popular_course_on_index_page").length == 1
                $("#popular_course_div").css('background-image','url()')
                $("#popular_course_banner").hide()
                @showallAccountCourses()
                $(".resource-row").hide()
                $("#more_courses").hide()
                $("#popular_course_paginating").hide()
              if $("#popular_course_div").find("#popular_course_on_index_page").length > 1
                @showPopularCourseonIndexPage()
                @showallAccountCourses()
              @showPopularCourseonIndexPage()
              @showallAccountCourses()
          ]
      else
        url = "api/v1/accounts/"+ENV.account_id+"/popular_courses"
        @$el.disableWhileLoading($.ajaxJSON url,'POST',data, onSuccess,onError)
        $("#popular_course_div").css('background-image','url("/images/pattern-bg.png")');
        @showallAccountCourses()
        @showPopularCourseonIndexPage()