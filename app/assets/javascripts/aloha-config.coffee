window.Aloha = window.Aloha || {}

Aloha.settings =
  modules: ['aloha', 'aloha/jquery']
  editables: '.editable-long-text, .editable-short-text'
  logLevels: 
    error: true
    warn: false
    info: false
    debug: false
    deprecated: false
  errorhandling: false
  sidebar:
    disabled: true
  ribbon: false
  locale: 'en'
  plugins:

    format:
      config: [  'b', 'i', 'p', 'sub', 'sup', 'del', 'title', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'pre', 'removeFormat' ]
      editables: '.editable-short-text': []

    list:
      config: [ 'ul', 'ol' ]
      editables: '.editables-short-text': []

    alignment:
      config: [ 'right', 'left', 'center', 'justify' ]
      editables: '.editables-short-text': []

    abbr:
      config: [ 'abbr' ]
      editables: '.editable-short-text': []

    link:
      config: [ 'a' ]
      editables: '.editable-short-text': []

      # all links that match the targetregex will get set the target
      # e.g. ^(?!.*aloha-editor.com).* matches all href except aloha-editor.com
      targetregex: '^(?!.*loo.no).*'

      # this target is set when either targetregex matches or not set
      # e.g. _blank opens all links in new window
      target: '_blank'

      onHrefChange: (obj, href, item) ->
        jQuery = Aloha.require 'aloha/jquery'
        if item
          jQuery(obj).attr 'data-name', item.name
        else
          jQuery(obj).removeAttr 'data-name'
    
    table:
      config: [ 'table' ]
      editables: '.editable-short-text': [ '' ]

    formatlesspaste:
      formatlessPasteOption : true
      button: true
      strippedElements : [
        "em"
        "small"
        "s"
        "cite"
        "q"
        "dfn"
        "abbr"
        "time"
        "code"
        "var"
        "samp"
        "kbd"
        "sub"
        "sup"
        "i"
        "b"
        "u"
        "mark"
        "ruby"
        "rt"
        "rp"
        "bdi"
        "bdo"
        "ins"
        "del"
        "pre"
      ]

      'numerated-headers':
        numeratedactive: false
  floatingmenu:
    width: 610 # with of the floating menu; auto calculated when not set
    behaviour: 'topalign' # 'float' (default), 'topalign', 'append'
    element: 'main' # use with 'append' behaviour option: HTML DOM ID of the element the FM should get the position from
    pin: false # boolean if set to true with behaviour 'append' the fm will be pinned to that position and scroll with the window
    draggable: true # boolean
    marginTop: -100 # number in px
    horizontalOffset: 0 # number in px -- used with 'topalign' behaviour
    topalignOffset: 110 # number in px -- used with 'topalign' behaviour


Aloha.onReady = ->
  #console.log "Aloha is ready!"
  $('.editable-long-text, .editable-short-text').each () ->
    id = $(this).attr('id')
    fnc = "window.Aloha.jQuery('#"+id+"')."
    a = $('<a href="#" class="btn btn-mini" style="display: block; width: 60px;">Source</a>').click (event) ->
      event.preventDefault()
      active = !!$('#'+ id + '-aloha').size()
      eval fnc + (if active then 'mahalo' else 'aloha') + '()'
      $(this).text if active then 'Editor' else 'Source'
    $(this).before(a)

  ###
  Aloha.require ["jquery", "ui/scopes", "ui/ui-plugin"], ($, Scopes, UiPlugin) ->
    toolbar = $(".aloha-toolbar")
    # Center and resize the toolbar
    toolbar.css
      position: "static"
      margin: "auto"

    $("#alohaContainer").append toolbar
    Scopes.setScope "Aloha.continuoustext"
    UiPlugin.showToolbar()

    # The child element must also be resized, don't know why
    toolbar.children().css width: 400
  ###

  Aloha.bind 'aloha-editable-deactivated', (event, myeditable) ->
    ###
    # Hide in 6 seconds
    window._alohaTC = window.setTimeout ( ->
      myeditable.editable.obj.animate( height: 60 )
    ), 6000
    ###


  Aloha.bind 'aloha-editable-activated', (event, myeditable) ->
    if(window._alohaTC?)
      window.clearTimeout window._alohaTC
    myeditable.editable.obj.animate( height: 280 )


