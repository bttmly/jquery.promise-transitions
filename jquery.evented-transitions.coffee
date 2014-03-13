do ( $ = jQuery ) ->

  defaults =
    notifyCount: 0

  changeClassTransitional = ( el, cl, kind, options ) ->
    settings = $.extend {}, defaults, options

    el[kind + "Class"]( cl )
    duration = parseInt( 1000 * parseFloat( el.css( "transition-duration" ).slice( 0, -1 ), 10 ), 10 )
    dfd = $.Deferred()

    if settings.notifyCount
      count = 0
      intervalId = setInterval ->
        count += 1
        dfd.notifyWith( el, [ ( count / settings.notifyCount ) ] )
      , ( duration / settings.notifyCount )

    if duration
      el.on "transitionend", ( event ) ->
        if settings.notifyCount
          clearInterval( intervalId )
        dfd.resolveWith( el, [ event ] )
    else
      dfd.resolveWith( el, [ false ] )
    
    return dfd.promise()

  # each method returns a promise that can be used with .then(), .done(), or .progress()
  # the context of each promise callback is the event on which the original method is called
  $.fn.extend
    addClassTransitional: ( cl, options ) ->
      options or= {}
      return changeClassTransitional( this, cl, "add", options )

    removeClassTransitional: ( cl, options ) ->
      options or= {}
      return changeClassTransitional( this, cl, "remove", options )

    toggleClassTransitional: ( cl, options ) ->
      options or= {}
      return changeClassTransitional( this, cl, "toggle", options2 )

