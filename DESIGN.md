Design
=======================================

One of the goals of this project is to try out some new technologies and work the way I
would want to work on my ideal project.

== Test everything

Various testing strategies can be employed to give you a mixure of benefits. We want:

* Fast feedback
* To be guided to an optimal design
* To be able to refactor mercilessly
* To deliver what the customer wants
* To release quickly and often


To enable us to do all this we need:

* Unit tests          - Fast feedback, optimal design
* Isolated tests      - Faster, more direct feedback (No database, no network, no other tests)
* Integration tests   - Tests a group of units (might need this depending on Acceptance coverage)
* Acceptance tests    - With examples so the customer knows they are getting what they want,
                        they also function as integration tests, showing that the combined modules
                        work together.

The higher up the test stack we go the more test coverage we get but the harder it becomes to track down issues.


Asset management
-----------------------------------------------------------

Done with rack-pipeline. JS and CSS stored in assets.
