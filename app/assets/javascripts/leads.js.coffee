# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#search-models').autocomplete
    source: ['arnold', 'animal', 'abeja', 'antilope']

  $("select#text_model_title").chosen().change () ->
    console.log "new value is + " + $(this).val()

  $('#insert_text_model').click (event) ->
    event.preventDefault
    $.ajax
      url: '/text_models/' + $("#text_model_title").val()
      dataType: 'json'
      success: (json) ->
        insertHtmlAtCursor json.body
      error: ->
        console.log 'error'
    return false

  $('#savedraft').click (event) ->
    event.preventDefault()
    $('#lead_draft').val($('#scheduled_message_body').val())
    $('form.edit_lead [type="submit"]').click();
    return false;
