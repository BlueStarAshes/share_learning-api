# frozen_string_literal: true

# Share Learning API web service
# configure based on environment
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  API_VER = 'api/v0.1'.freeze

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
    # Setting Youtube API key
    YouTube::YouTubeAPI.config.update(api_key: config.YOUTUBE_API_KEY)
  end

  after do
    content_type 'application/json'
  end

  get '/?' do
    {
      status: 'OK',
      message: "ShareLearningAPI latest version endpoints are at: /#{API_VER}/"
    }.to_json
  end
end
