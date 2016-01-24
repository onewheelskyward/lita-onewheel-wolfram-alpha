lita-onewheel-wolfram-alpha
----

.. image:: https://coveralls.io/repos/github/onewheelskyward/lita-onewheel-wolfram-alpha/badge.svg?branch=master
  :target: https://coveralls.io/github/onewheelskyward/lita-onewheel-wolfram-alpha?branch=master
.. image:: https://travis-ci.org/onewheelskyward/lita-onewheel-wolfram-alpha.svg?branch=master
  :target: https://travis-ci.org/onewheelskyward/lita-onewheel-wolfram-alpha

Queries Wolfram Alpha for the text specified.

Installation
----
Add lita-onewheel-wolfram-alpha to your Lita instance's Gemfile:

``gem 'lita-onewheel-wolfram-alpha'``


Configuration
----
```
Lita.configure do |config|
  config.handlers.wolfram_alpha.app_id = 'yourwolframappid'
  config.handlers.wolfram_alpha.api_uri = 'http://api.wolframalpha.com/v2/query?input=[query]&appid=[appid]'
end
```

Usage
----
bot: alpha pi

License
----
[MIT](http://opensource.org/licenses/MIT)
