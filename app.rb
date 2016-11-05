# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'share_learning'

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = settings.root

  API_VER = 'api/v0.1'

  get '/?' do
    # "ShareLearningAPI latest version endpoints are at: /#{API_VER}/"
    "Hello World"
  end
end
