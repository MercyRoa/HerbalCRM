# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#search-models').autocomplete
    source: ['arnold', 'animal', 'abeja', 'antilope']

  # Edit Resume
  $('#btn-edit-resume').click (event) ->
    $btn = $('#btn-edit-resume')
    if ( $btn.text() == 'Edit' )
      event.preventDefault()
      Aloha.jQuery('#leadResume').aloha()
      $('#leadResume').focusToEnd()
      $btn.text('Save')
    else
      if( $(this).attr('id') == 'leadResume' )
        return
      Aloha.jQuery('#leadResume').mahalo()
      $('#lead_resume').val($('#leadResume').html())
      $('form.edit_lead [type="submit"]').click();
      $btn.text('Edit')
      $('#leadResume').css(height: 'auto')


  #Text models cache
  text_models = []
  $('#insert_text_model').click (event) ->
    event.preventDefault()
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

  # Save draft
  $('#savedraft').click (event) ->
    event.preventDefault()
    $('#lead_draft').val($('#scheduled_message_body-aloha').html())
    $('form.edit_lead [type="submit"]').click();
    return false;

  # Auto save draft
  ###
    window._autoSaveTC = window.setTimeout ( ->
       $('#savedraft').click()
    ), 60000
  ###

  #editable options
  $('form .editable').each ->
    $(this).append '<a class="btn btn-mini edit" style="display: none;"><i class="icon-pencil"></i></a>'
    $editable = $(this)
    $(this).find('input, select').focusout ->
      $editable.find('.static').text( $(this).val() ).show() # show static label
      $(this).hide() # hide input
      $editable.find('a.edit').hide() # hide edit pencil
      $('form.edit_lead [type="submit"]').click() # Send form
      $editable.removeClass('editing')
  .hover ((event) ->
    if !$(this).hasClass('editing')
      $(this).find('a.edit').fadeIn()
  ), (event) ->
    if !$(this).hasClass('editing')
      $(this).find('a.edit').fadeOut()

  $('.editable .edit, .editable .static').click ->
    $editable = $(this).parents('.editable')

    if ( $editable.hasClass('editing') )
      return false;

    $editable.addClass('editing')
    $editable.find('.static').hide()
    $editable.find('a.edit').show()
    $editable.find('input, select').show().focus()


  $(".response_button").click ->
    $response = $(this).next().next()
    $fast_response = $(this).next().next().next()
    $response.toggle "slow"
    $fast_response.hide()

  $(".fast_response_button").click ->
    $response = $(this).next()
    $fast_response = $(this).next().next()
    $fast_response.toggle "slow"
    $response.hide()

  $(".button_text_model").click ->
      alert $(this).attr('name')




