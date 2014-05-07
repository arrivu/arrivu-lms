define [
  'jquery'
  'jst/HomePages/LearnersReviewCollectionView'
  'compiled/views/HomePages/LearnersReviewView'
  'compiled/views/PaginatedCollectionView'
], ($, template, LearnersReview, PaginatedCollectionView) ->

  class LearnersReviewCollectionView extends PaginatedCollectionView

    template: template
    itemView: LearnersReview