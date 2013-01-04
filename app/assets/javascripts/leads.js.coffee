# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#search-models').autocomplete
    source: ['arnold', 'animal', 'abeja', 'antilope']

  text_models = []
  $('#insert_text_model').click (event) ->
    event.preventDefault
    $('body').modalmanager('loading');

    tm = $("#text_model_title").val()
    if (text_models[tm])
      console.log 'already on cache'
      insertHtmlAtCursor text_models[tm], $('#scheduled_message_body-aloha')
      $('body').modalmanager('loading');
    else
      $.ajax
        url: '/text_models/' + $("#text_model_title").val()
        dataType: 'json'
        success: (json) ->
          text_models[tm] = json.body
          insertHtmlAtCursor json.body, $('#scheduled_message_body-aloha')
          $('body').modalmanager('loading');
        error: ->
          console.log 'error'
          $('body').modalmanager('loading');
    return false

  $('#savedraft').click (event) ->
    event.preventDefault()
    $('#lead_draft').val($('#scheduled_message_body-aloha').html())
    $('form.edit_lead [type="submit"]').click();
    return false;
