jquery.promise-transitions
==========================

A jQuery plugin with modified methods mirroring `.addClass()`, `.removeClass()`, and `.toggleClass()` but that instead return promises that resolve once transition changes complete.

There are some serious shortcomings in the TransitionEvent API, including, most notably, the complete lack of anything like TransitionStart. Use with caution! If you add/remove/toggle a class that doens't change any transitioning properties, but the element does have a `transition-duration`, the promise will never resolve (because there is no way to check if a transition has started).