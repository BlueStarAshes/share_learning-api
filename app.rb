require 'sinatra'
require 'econfig'
require 'share_learning'

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = settings.root

  # Setting Youtube API key
  YouTube::YouTubeAPI
    .config
    .update(api_key: config.YOUTUBE_API_KEY)

  API_VER = 'api/v0.1'.freeze

  get '/?' do
    "ShareLearningAPI latest version endpoints are at: /#{API_VER}/"
  end
end
