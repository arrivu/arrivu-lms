require [
  'compiled/collections/CoursePricingCollection',
  'compiled/views/CoursePricing/IndexView'
  'compiled/views/CoursePricing/CoursePricingsCollectionView'
], (CoursepricingCollection, IndexView, CoursePricingsCollectionView) ->

  # Collections

  coursePricingCollection = new CoursepricingCollection

  coursePricingsCollectionView = new CoursePricingsCollectionView
    collection: coursePricingCollection

  @app = new IndexView
    coursePricingsCollectionView: coursePricingsCollectionView
    el: '#course_pricings'

  @app.render()
  coursePricingCollection.fetch()