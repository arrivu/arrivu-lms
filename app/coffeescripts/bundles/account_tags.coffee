require [
  'compiled/collections/AccountTagsCollection',
  'compiled/views/AccountTags/IndexView'
  'compiled/views/AccountTags/AccountTagsCollectionView'
], (AccountTagsCollection, IndexView, AccountTagsCollectionView) ->

  # Collections

  accountTagCollection = new AccountTagsCollection

  accountTagsCollectionView = new AccountTagsCollectionView
    collection: accountTagCollection

  @app = new IndexView
    accountTagsCollectionView: accountTagsCollectionView
    el: '#account_tags'

  @app.render()
  accountTagCollection.setParam('source', "course")
  accountTagCollection.fetch()