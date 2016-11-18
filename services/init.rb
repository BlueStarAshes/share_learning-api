# frozen_string_literal: true
require 'dry-monads'
require 'dry-container'
require 'share_learning'

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end