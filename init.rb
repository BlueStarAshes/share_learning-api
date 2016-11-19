# frozen_string_literal: true
Dir.glob('./{config,models,services,values,representers,controllers}/init.rb').each do |file|
  require file
end
