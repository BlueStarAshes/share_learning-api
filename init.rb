# frozen_string_literal: true
Dir.glob('./{config,models,decorators,controllers}/init.rb').each do |file|
  require file
end
