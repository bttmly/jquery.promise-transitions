# jQuery Evented Transitions: Notes

- `$(x).css("transition-duration")` returns a **string** in the form:
`1.5s, 2s, 2.5s`

- `$(x).css("transition")` returns a **string** in the form: 
`background-color 1.5s ease-in-out 0s, width 2s ease-in-out 0s, height 2.5s ease-in-out 0s`

Is there any way to tell what properties are transitioning **before the `transitionend` event**? The `transitionend` event has a `propertyName` property.

Is there a use case that requires knowing the property being transitioned before transitionend?
- Any time you want to know if a specific property has started to transition.
- Hooking into `.progress()` only for a specific transition property's `.notify()` calls.

Assuming there is no way to know which property a transition is acting on prior to a `transitionend` event firing, where does that leave us? 

*We can:*
- Fire on `transitionend` for a specific property, either by a.) filtering `event.originalEvent.propertyName` in the event handler, or b.) triggering custom events in the plugin that mimic transitionend events but are namespaced to their `propertyName`.

*We can't:*
- ... use the `.notify()`--`.progress()` system to alert at intervals, because if there are different transition durations for different properties, we can't be sure which one we want to observe. Maybe always use the longest duration?
- ...know how many properties are transitioning, at least without doing some extensive CSS parsing. This is a problem, since if we're using `Deferred.promise()` we can only resolve each promise once. Perhaps we could `.notify()` on each `transitionend` and never actually resolve the promise?

How the hell can we avoid attaching more and more event handlers if we don't know when it's safe to remove them?

## For Now...
It's only safe to work with elements with a single transition-duration. It's the only way to...
- Know when the transition has started and ended.
- Safely detach event handlers.
- Use the .notify() interface unambiguously.

## Unfortunately...
JavaScript has a very limited TransitionEvent API. Ideally we'd be able to change an element's CSS selectors and listen to property changes as they transition. Short of that, it seems like directly manipulating property changes with JS is the only way to go, which is exactly what we **don't** want to do.

An ugly way to attack this would be to create a system based around reading `transition-duration` and using `setTimeout` to try to get everything working, and adding a custom event abstraction layer on top. There is still the problem of figuring out which properties are actually in transition, however.