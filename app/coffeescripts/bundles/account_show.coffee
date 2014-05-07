require ['jquery', 'compiled/behaviors/autocomplete','jquery.tokeninput'], ($) ->
  $(document).ready ->
    # Add an on-select event to the course name autocomplete.
    $('#course_name').on 'autocompleteselect', (e, ui) ->
      path = $(this).data('autocomplete-options')['source'].replace(/\?.+$/, '')
      window.location = "#{path}/#{ui.item.id}"
    $ ->
      $('#course_tag_tokens').tokenInput '/context_tags.json'
      prePopulate: $('#course_tag_tokens').data('load')