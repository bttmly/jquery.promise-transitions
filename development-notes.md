# jQuery Evented Transitions: Notes

- `$(x).css("transition-duration")` returns a __string__ in the form:
`1.5s, 2s, 2.5s`

- `$(x).css("transition")` returns a __string__ in the form: 
`background-color 1.5s ease-in-out 0s, width 2s ease-in-out 0s, height 2.5s ease-in-out 0s`

Is there any way to tell what properties are transitioning __before the `transitionend` event__? The `transitionend` event has a `propertyName` property.

Is there a use case that requires knowing the property being transitioned before transitionend?
- Any time you want to know if a specific property has started to transition.
- Hooking into `.progress()` only for a specific transition property's `.notify()` calls.

Assuming there is no way to know which property a transition is acting on prior to a `transitionend` event firing, where does that leave us? 

*We can:*
- Fire on `transitionend` for a specific property, either by a.) filtering `event.originalEvent.propertyName` in the event handler, or b.) triggering custom events in the plugin that mimic transitionend events but are namespaced to their `propertyName`.

*We can't:*
- Use the `.notify()`--`.progress()` system to alert at intervals, because if there are different transition durations for different properties, we can't be sure which one we want to observe. Maybe always use the longest duration?
- Know how many properties are transitioning, at least without doing some extensive CSS parsing. This is a problem, since if we're using `Deferred.promise()` we can only resolve each promise once. Perhaps we could `.notify()` on each `transitionend` and never actually resolve the promise?