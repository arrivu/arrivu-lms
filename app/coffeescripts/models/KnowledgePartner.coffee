define [
  'Backbone'
  'underscore'
], ({Model}, _) ->
  class KnowledgePartner extends Model

    resourceName: "knowledge_partners"

    urlRoot: -> "knowledge_partners"


    # Method Summary
    #   See backbones explaination of a validate method for in depth
    #   details but in short, if your return something from validate
    #   there is an error, if you don't, there are no errors. Throw
    #   in the error object to any validation function you make. It's
    #   passed by reference dawg.
    # @api override backbone
    validate: (attrs) ->
      errors = {}
      errors unless _.isEmpty errors
