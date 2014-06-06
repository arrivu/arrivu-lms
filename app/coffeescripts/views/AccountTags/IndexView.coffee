define [
  'jquery'
  'i18n!account_tags'
  'str/htmlEscape'
  'jst/AccountTags/IndexView'
  'compiled/views/AccountTags/EditView'
  'compiled/models/AccountTag'
], ($,I18n, htmlEscape, template,EditView, AccountTag) ->

  class IndexView extends Backbone.View

    @child 'accountTagsCollectionView', '[data-view=account_tags]'

    template: template

