#define [
#  'jquery'
#  'str/htmlEscape'
#  'jst/rewards/RewardsCollectionView'
#  'compiled/views/PaginatedCollectionView'
#  'i18n!rewards'
#], ($, htmlEscape, template, PaginatedCollectionView, I18n) ->
#
#  class RewardsCollectionView extends PaginatedCollectionView
#
#    template: template
##    itemView: ExternalToolView