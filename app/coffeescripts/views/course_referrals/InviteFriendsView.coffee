define [
  'jquery'
  'underscore'
  'Backbone'
  'jst/course_referrals/InviteFriendsView'
  'compiled/views/course_referrals/InviteFriendsErrorView'
], ($, _, Backbone, template,InviteFriendsErrorView) ->
  class InviteFriendsView extends Backbone.View
    template: template
    className: 'invite-friends'

    events:
      "click #referral_submit": "sendInvites"


    sendInvites: ->
      @.$el.find('#invite_friends_error_box').empty() # Clear error box every time
      errored_users = []
      emails = $('#referral_referral_emails').val().split(',')
      emails.map (email) ->
        unless isValidEmailAddress(email)
          errored_users.push email
      valid_emails = []
      i = 0
      $.grep emails, (el) ->
        valid_emails.push el  if $.inArray(el, errored_users) is -1
        i++
      if errored_users.length > 0
        @renderErrorView(errored_users)
      else
        @model.save(valid_emails: valid_emails)

    renderErrorView:(errored_users) =>
      @.$el.find('#invite_friends_error_box').empty() # Clear error box every time
      inviteFriendsErrorView = new InviteFriendsErrorView
        errored_users_list: errored_users
      @$el.find('#invite_friends_error_box').append inviteFriendsErrorView.render().el



    initialize: ->
      @email_subject = @options.email_subject
      @email_text = @options.email_text
      @domain_url = @options.domain_url
      @fb_reference = @options.fb_reference
      @tw_reference = @options.tw_reference
      @li_reference = @options.li_reference
      @go_reference = @options.go_reference
      @gl_reference = @options.gl_reference


    toJSON: ->
      json = super

      json['email_subject'] = @email_subject
      json['email_text'] = @email_text
      json['domain_url'] = @domain_url
      json['fb_reference'] = @fb_reference.short_url_code
      json['tw_reference'] = @tw_reference.short_url_code
      json['li_reference'] = @li_reference.short_url_code
      json['go_reference'] = @go_reference.short_url_code
      json['gl_reference'] = @gl_reference.short_url_code

      json



    isValidEmailAddress = (emailAddress) ->
      pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i)
      pattern.test emailAddress
