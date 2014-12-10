# specroutes

[![Build Status](https://travis-ci.org/0robustus1/specroutes.svg?branch=master)](https://travis-ci.org/0robustus1/specroutes)

- autogenerate WADL-specification from routes
- Add mechanism to create routes based on query-string and hierarchical part

## Installation

Just add `gem 'specroutes', '~> 0.0.1'` to your *Gemfile*, perform
`bundle install` and your ready.

Additionally you'll need to make a change to your *config/routes.rb*:

```ruby
# If you Application is named 'Dummy::Application'
Specroutes.define(Dummy::Application.routes) do
  # ...
end
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

All `specified_`\* methods support their usual arguments and additionally the
following ones:

- `specified_get '/cars/' => 'cars#index', doc: {lang: 'en', title: 'Some title', body: 'Some body'}`  
  add documentation to the specification for the resulting route.
- `specified_get 'cars/:id?make=string'`  
  will additionally add a constraint to the route which will make the
  query-parameter `make` mandatory and specifies it as having a type of
  `xsd:string`.

[WADL]: http://www.w3.org/Submission/wadl/
