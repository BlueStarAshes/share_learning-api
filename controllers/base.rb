# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  API_VER = 'api/v0.1'.freeze

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
    # Setting Youtube API key
    YouTube::YouTubeAPI.config.update(api_key: config.YOUTUBE_API_KEY)
  end

  get '/?' do
    "ShareLearningAPI latest version endpoints are at: /#{API_VER}/"
  end
end
