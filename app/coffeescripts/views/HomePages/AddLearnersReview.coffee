define [
  'jquery'
  'jst/HomePages/AddLearnersReviewView'
  'compiled/views/ValidatedFormView'
  'compiled/jquery/fixDialogButtons'
], ($, template, ValidatedFormView) ->

  class AddLearnersReview extends ValidatedFormView
    template: template
    tagName: 'form'
    id: 'learners_review_form'

    className: 'validated-form-view form-horizontal bootstrap-form'

    afterRender: ->
      super
      @$el.dialog
        title: 'Add Learners Review'
        width:  600
        height: "auto"
        resizable: true
        close: => @$el.remove()
        buttons: [
          class: "btn-primary"
          text:  'Submit'
          'data-text-while-loading': 'Saving...'
          click: => @submit()
        ]
      @$el.submit (e) =>
        @submit()
        return false
      this

    submit: ->
      this.$el.parent().find('.btn-primary').removeClass('ui-state-hover')
      super

