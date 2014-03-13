do ( $ = jQuery ) ->

  defaults =
    notifyCount: 0

  changeClassTransitional = ( el, cl, kind, options ) ->
    settings = $.extend {}, defaults, options

    el[kind + "Class"]( cl )

    dfd = $.Deferred()

    duration = el.css( "transition-duration" ).split( ", " )

    # Resolve deferred immediately if we have multiple durations, or duration is 0s.
    # Then return the promise.
    if duration.length > 1 or not duration[0]
      dfd.resolveWith( el, [ false ] )
      return dfd.promise()

    duration = parseInt( 1000 * parseFloat( duration[0].slice( 0, -1 ), 10 ), 10 )

    if settings.notifyCount
      count = 0
      interval = duration / settings.notifyCount
      intervalId = setInterval ->
        count += 1
        percent = count / settings.notifyCount
        elapsed = count * interval
        dfd.notifyWith( el, [ elapsed, percent ] )
      , interval

    el.on "transitionend", ( teEvent ) ->
      prop = teEvent.originalEvent.propertyName
      
      e = $.Event "jqetTransitionEnd",
        propertyName: prop
        originalEvent: teEvent.originalEvent

      el.trigger( e )
      dfd.resolveWith( el, [ e ] )
      el.off( "transitionend" )
  
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

