Lita.configure do |config|
  config.handlers.wolfram_alpha.app_id = 'yourwolframappid'
  config.handlers.wolfram_alpha.api_uri = 'http://api.wolframalpha.com/v2/query?input=[query]&appid=[appid]'
end
