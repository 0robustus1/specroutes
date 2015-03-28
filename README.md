# specroutes

[![Join the chat at https://gitter.im/0robustus1/specroutes](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/0robustus1/specroutes?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/0robustus1/specroutes.svg?branch=master)](https://travis-ci.org/0robustus1/specroutes)
[![Coverage Status](https://img.shields.io/coveralls/0robustus1/specroutes.svg)](https://coveralls.io/r/0robustus1/specroutes)

- autogenerate WADL-specification from routes
- Add mechanism to create routes based on query-string and hierarchical part

## Installation

Just add `gem 'specroutes', '~> 0.0.1'` to your *Gemfile*, perform
`bundle install` and your ready.

Additionally you'll need to make a change to your *config/routes.rb*:

- **From:**

  ```ruby
  # Where 'Dummy' should be your application-name
  Dummy::Application.routes.draw do
    # route definitions...
  end
  ```
- **To:**

  ```ruby
  # If your application is named 'Dummy::Application'
  Specroutes.define(Dummy::Application.routes) do
    # route definitions...
  end
  ```


- Alternatively you can just run the generator provided by the gem:

  ```bash
  rails generate specroutes:routes
  ```

## Usage

After changing the initial routes call you are still able to call any normal
route-method (`resources`, `resource`, `get`, `post`, `put`, `delete`,
`match`). Additionally we provide the following methods which will create
specification ([WADL][WADL] format) and allow query-strings for route
definition:

- `specified_get` (specification generating equivalent of `get`)
- `specified_post` (specification generating equivalent of `post`)
- `specified_put` (specification generating equivalent of `put`)
- `specified_delete` (specification generating equivalent of `delete`)

All `specified_*` methods support their usual arguments and additionally the
following ones:

- add documentation to the specification for the resulting route.

  ```ruby
  specified_get '/cars/' => 'cars#index', doc: {
    lang: 'en',
    title: 'Some title',
    body: 'Some body'
  }
  ```
- will additionally add a constraint to the route which will make the
  query-parameter `make` mandatory and specifies it as having a type of
  `xsd:string`.

  ```ruby
  specified_get 'cars/:id?make=string'
  ```

You can also provide constraints through the usual `constraints:` key. However
if you are using query-parameters in your route (and therefore instruct
specroutes to create constraints by itself), you can only use the
Object#matches? way of providing constraints. Regex-based constraints are not
supported, yet (but they will be soon).

Additional metadata can be provided inside the block of a `specified_*` call.
Currently there are three methods supported:

- `accept(mime_type, constraint: false)`, adds a possible *representation* for
  the mime-type.  If the constraint-value is set to true it will add a
  MimeTypeConstraint to the route, such that the route will only match if the
  request contains the mime_type as it's primary header. Multiple accept-calls
  with constraint set to true will act like a logical *or*.
- `doc(lang: 'en', title:, body: '')` another way to specify documentation for a route.
- `match_block(&block`, a block passed to the internal `match`-call.

### Specification generation

Specroutes produces an internal representation of the specified routes and
memoizes it inside your application. If you want to access the specification in
a common format (e.g. XML per WADL-standardization) you'll need to perform the
generation. This can currently be done in two ways.

- By calling the rake task (which will print the specification to stdout):

  ```bash
  bundle exec rake specroutes:specification
  ```


- You can also obtain the XML-specification programatically by calling the
following method:

  ```ruby
  Specroutes.serialize
  ```


[WADL]: http://www.w3.org/Submission/wadl/
