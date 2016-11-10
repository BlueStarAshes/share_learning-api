# frozen_string_literal: true
Dir.glob('./{config,models}/init.rb').each do |file|
  require file
end
