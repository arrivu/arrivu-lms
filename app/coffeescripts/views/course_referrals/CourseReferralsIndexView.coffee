define [
  'jquery'
  'underscore'
  'Backbone'
  'jst/course_referrals/courseReffealsIndex'
  'compiled/views/course_referrals/InviteFriendsView'
  'compiled/models/Referral'
], ($, _, Backbone, template, InviteFriendsView,Referral) ->
  class CourseReferralsIndexView extends Backbone.View

    course_referral = new Referral $.parseJSON(ENV.COURSE_REFERRAL).referral

    template: template

    els:
      "#referral_tabs": "$referralTabs"

    # Method Summary
    #   Enable tabs for invite friends/My references/My rewards
    #   And  append tab views
    # @api custom backbone override
    afterRender: ->
      @$referralTabs.tabs()
      inviteFriendsView = new InviteFriendsView
        model: course_referral

        title_name: $.parseJSON(ENV.COURSE_CONTEXT).title_name
        email_subject: $.parseJSON(ENV.COURSE_REFERRAL).referral.email_subject
        email_text: $.parseJSON(ENV.COURSE_REFERRAL).referral.email_text
        domain_url: eval(ENV.DOMAIN_URL)
        fb_reference:  $.parseJSON(ENV.COURSE_REFERENCE_FB).reference
        tw_reference:  $.parseJSON(ENV.COURSE_REFERENCE_TW).reference
        li_reference:  $.parseJSON(ENV.COURSE_REFERENCE_LI).reference
        go_reference:  $.parseJSON(ENV.COURSE_REFERENCE_GO).reference
        gl_reference:  $.parseJSON(ENV.COURSE_REFERENCE_GL).reference

      @$el.find('#invite').append inviteFriendsView.render().el

    toJSON: ->
      @options


