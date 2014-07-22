#
# Copyright (C) 2014 Arrivu Info Tech pvt.
#
# This file is part of Arrivu.

# @API ClassCategories
#
# ClassCategories are the way to categorise
# Modules.
#
# @model ClassCategories 1
#     {
#       "id": 1,
#       "name": "Pre Class Videos",
#       "Position": 1
#       }
#     }
#


class ClassCategoriesApiController < ApplicationController
  before_filter :require_context

  # @API List class categories
  #
  # List the class categories in a course
  #
  # @example_request
  #     curl -H 'Authorization: Bearer <token>' \
  #          https://<arrivulms>/api/v1/courses/222/class_categories
  #
  # @returns [ClassCategories]

  def index
    if authorized_action(@context, @current_user, :read)
      class_categories = [{id: 1,name: ContentTag::PRE_CLASS_VIDEO_NAME,position: ContentTag::PRE_CLASS_VIDEO_POSITION},
                          {id: 2,name: ContentTag::PRE_CLASS_RECORDING_NAME,position: ContentTag::PRE_CLASS_RECORDING_POSITION},
                          {id: 3,name: ContentTag::PRE_CLASS_PRESENTATION_NAME,position: ContentTag::PRE_CLASS_PRESENTATION_POSITION},
                          {id: 4,name: ContentTag::PRE_CLASS_READING_MATERIALS_NAME,position: ContentTag::PRE_CLASS_READING_MATERIALS_POSITION},
                          {id: 5,name: ContentTag::PRE_CLASS_ASSIGNMENTS_NAME,position: ContentTag::PRE_CLASS_ASSIGNMENTS_POSITION}]
      render :json => class_categories
    end
  end
end