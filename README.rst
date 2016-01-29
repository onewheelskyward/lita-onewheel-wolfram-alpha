lita-onewheel-wolfram-alpha
===========================

.. image:: https://coveralls.io/repos/github/onewheelskyward/lita-onewheel-wolfram-alpha/badge.svg?branch=master
  :target: https://coveralls.io/github/onewheelskyward/lita-onewheel-wolfram-alpha?branch=master
.. image:: https://travis-ci.org/onewheelskyward/lita-onewheel-wolfram-alpha.svg?branch=master
  :target: https://travis-ci.org/onewheelskyward/lita-onewheel-wolfram-alpha

Queries Wolfram Alpha for the text specified.

Installation
------------
Add lita-onewheel-wolfram-alpha to your Lita instance's Gemfile:

``gem 'lita-onewheel-wolfram-alpha'``


Configuration
-------------
Get yourself a Wolfram Alpha app id here: https://developer.wolframalpha.com/portal/apisignup.html, then place the ID in the config.
::
  Lita.configure do |config|
    config.handlers.onewheel_wolfram_alpha.app_id = 'yourwolframappid'
    config.handlers.onewheel_wolfram_alpha.api_uri = 'http://api.wolframalpha.com/v2/query?input=[query]&appid=[appid]'
  end

Usage
-----
:alpha pi: returns "3.14......"

License
-------
MIT
