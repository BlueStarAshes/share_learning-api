# frozen_string_literal: true
Dir.glob('./{config}/init.rb').each do |file|
  require file
end
