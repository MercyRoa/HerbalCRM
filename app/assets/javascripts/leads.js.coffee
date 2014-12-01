# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # delete lead on index
  $('.delete_lead[data-remote=true]').on 'ajax:success', (event, data, status, xhr) ->
    $divlead = $(this).parents('div.lead_box_lead')
    $divlead.fadeOut();
    $divlead.next('hr').remove()

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
    
    tm = $("#text_model_title").val()
    if (text_models[tm])
      console.log 'already on cache'
      insertHtmlAtCursor text_models[tm], $('#scheduled_message_body-aloha')
      $('body').modalmanager('loading');
    else
      $('body').modalmanager('loading');
      $.ajax
        url: '/text_models/' + $("#text_model_title").val()
        dataType: 'json'
        success: (json) ->
          text_models[tm] = json.body
          insertHtmlAtCursor json.body, $('#scheduled_message_body-aloha')
          setTimeout ( -> $('body').modalmanager('loading') ), 1000
        error: ->
          console.log 'error'
          setTimeout ( -> $('body').modalmanager('loading') ), 1000
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
    id = $(this).attr("id").replace(/[^\d.]/g, "")
    $("#response"+id).toggle "slow"
    $("#response"+id).find(".chzn").chosen();
    $(".fast_response").hide()
    $(".history").hide()

  # this is for index.haml
  $('.insert_text_model').click (event) ->
    event.preventDefault()
    
    lead_id = $(this).attr('rel')
    $textarea = $(this).parents('form').find('textarea')

    tm = $(".text_model_title[rel="+lead_id+"]").val()

    Aloha.jQuery('#textarea_body'+lead_id).mahalo()
    if (text_models[tm])
      $textarea.val( text_models[tm] )
    else
      $('body').modalmanager('loading')
      $.ajax
        url: '/text_models/' + tm
        dataType: 'json'
        success: (json) ->
          text_models[tm] = json.body
          $textarea.val( text_models[tm] )
          Aloha.jQuery('#textarea_body'+lead_id).aloha()

          setTimeout ( -> $('body').modalmanager('loading') ), 1000
          
        error: ->
          console.log 'error'
          setTimeout ( -> $('body').modalmanager('loading') ), 1000
    

    return false


  $(".fast_response_button").click ->
    id = $(this).attr("id").replace(/[^\d.]/g, "")
    $(".response").hide()
    $("#fast_response"+id).toggle "slow"
    $(".history").hide()

  $(".link_history").click ->
    id = $(this).attr("id").replace(/[^\d.]/g, "")
    $(".response").hide()
    $(".fast_response").hide()
    if $("#history"+id).is(":visible")
      $("#history"+id).hide "slide",
        direction: "right"
      , 1000
    else
      $(".history").hide()
      $("#history"+id).show "slide",
        direction: "right"
      , 1000

  # Index Fast response button      
  $(".button_starred").click ->
    id = $(this).attr("id").replace(/[^\d.]/g, "")
    $("#fast_response"+id).hide("slow")
    $("#fast_response"+id).parent().parent().css("background-color", "#E6E6E6");

  $(".button_send").click ->
    id = $(this).attr("id").replace(/[^\d.]/g, "")
    $("#response"+id).hide("slow")
    $("#response"+id).parent().parent().css "background-color", "#E6E6E6"

  $(".savedraft").click (event) ->
    id = $(this).attr("id").replace(/[^\d.]/g, "")
    $el = $(this)
    $("#response"+id).hide("slow")
  
#    event.preventDefault()
#    $('#lead_draft').val($('#scheduled_message_body-aloha').html())
#    $('form.edit_lead [type="submit"]').click();
#    return false;
#
#    # Auto save draft
#    ###
#      window._autoSaveTC = window.setTimeout ( ->
#         $('#savedraft').click()
#      ), 60000
#    ###
  $(".nav nav-tabs").tab()

  $(document).on "click", ".close_box", ->
     $(this).parent().hide "slide",
        direction: "right"
      , 1000












