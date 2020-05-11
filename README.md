Simple page navigation sample

Demonstrates the following scenarios in these commits
- 7b7be86 page routing, e.g. '#/login'
- 1d704b5 credential caching, JSON encoding & decoding, localStorage
- a3f88f2 load cached credentials via flags
- 61f6998 add returnMessage and multi-tab support via windows eventListener
- 10df9a6 protected routes, e.g. '#/settings'

Made it look nicer with bare bones UI
- ec1a803 theme w/ bootstrap 4.3

There are some rudimentary unit tests to demonstrate some basic coverage with:
- elm-explorations/test module usage, mostly covering JSON and Routing cases

Two unaddressed items (among many) are: 
- testing of the Elm ports which will require an integration framework
- adding dynamic coverage for the Enums, such as the Route tests. As-is you'll need
  to remember to add new Routes to the parser.oneOf statement, for example. It would
  be better to iterate over all possible types and test they're all handled.
