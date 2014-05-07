define [
  'jquery'
  'jst/HomePages/AccountStatistics'
], ($, template ) ->

  class AccountStatisticsView extends Backbone.View

    template: template
    el: ".account_statistics_item"

