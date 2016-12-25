# frozen_string_literal: true
require 'econfig'
require 'shoryuken'

require_relative '../lib/init.rb'
require_relative '../values/init.rb'
require_relative '../config/init.rb'
require_relative '../models/init.rb'
require_relative '../representers/init.rb'
require_relative '../services/init.rb'

class LoadNewCoursesWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.configure_client do |shoryuken_config|
    shoryuken_config.aws = {
      access_key_id:      LoadNewCoursesWorker.config.AWS_ACCESS_KEY_ID,
      secret_access_key:  LoadNewCoursesWorker.config.AWS_SECRET_ACCESS_KEY,
      region:             LoadNewCoursesWorker.config.AWS_REGION
    }
  end

  FaceGroup::FbApi.config.update(
    client_id:      LoadNewCoursesWorker.config.FB_CLIENT_ID,
    client_secret:  LoadNewCoursesWorker.config.FB_CLIENT_SECRET
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.COURSE_QUEUE, auto_delete: true

  def perform(_sqs_msg)
    result = LoadCoursesFromAPI.call('')
    puts "RESULT: #{result.value}"

    HttpResultRepresenter.new(result.value).to_status_response
  end
end