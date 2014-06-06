define [
  'jquery'
  'i18n!account_tags'
  'str/htmlEscape'
  'jst/CoursePricing/IndexView'
  'compiled/views/CoursePricing/AddCoursePrice'
  'compiled/views/CoursePricing/EditView'
  'compiled/models/CoursePricing'
], ($,I18n, htmlEscape, template, AddCoursePrice,EditView, CoursePrice) ->

  class IndexView extends Backbone.View

    @child 'coursePricingsCollectionView', '[data-view=course_pricings]'

    template: template

    events:
      'click .add_tool_link': 'addCoursePrice'
      'click [data-edit-course_pricings]': 'editCoursePrice'
      'click [data-delete-course_pricings]': 'deleteCoursePrice'

    afterRender: ->
      @showCoursePriceView()

    showCoursePriceView: =>
      @coursePricingsCollectionView.collection.fetch()
      @coursePricingsCollectionView.show()

    addCoursePrice: ->
      newCoursePrice = new CoursePrice
      newCoursePrice.on 'sync', @onCoursePriceSync
      @addCoursePriceView = new AddCoursePrice
        model: newCoursePrice
      @addCoursePriceView.render()

    editCoursePrice: (event) ->
      view = @$(event.currentTarget).closest('.course_pricings_item').data('view')
      course_price = view.model
      course_price.on 'sync', @onCoursePriceSync
      @editCoursePriceView = new EditView(model: course_price).render()

    deleteCoursePrice:(event) ->
      deleteview = @$(event.currentTarget).closest('.course_pricings_item').data('view')
      delete_course_price_item = deleteview.model
      deletemsg = "Are you sure want to remove the price of this Course?"
      dialog = $("<div>#{deletemsg}</div>").dialog
        modal: true,
        resizable: false
        title: I18n.t('delete', 'Delete Price of') + ' ' + ENV.course_name + '?'
        buttons: [
          text: 'Cancel'
          click: => dialog.dialog 'close'
        ,
          text: 'Delete'
          click: =>
            delete_course_price_item.destroy()
            dialog.dialog 'close'
            $.flashMessage(htmlEscape(I18n.t('course_price_deleted_message', " Price deleted successfully!")))
        ]

    onCoursePriceSync: =>
      @addCoursePriceView.remove() if @addCoursePriceView
      @showCoursePriceView()
      $.flashMessage(htmlEscape(I18n.t('course_price_saved_message', "Course Price saved successfully!")))