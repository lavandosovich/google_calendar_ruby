require 'bundler/setup'
require 'sinatra/base'
Bundler.require

ENV['SINATRA_ENV'] ||= 'development'

require_relative '../app/controllers/application_controller.rb'

#Dir[File.join(File.dirname(__FILE__), '../app/models', '*.rb')].
#  each { |f| require f }
Dir[File.join(File.dirname(__FILE__), '../app/controllers', '*.rb')].sort.
  each { |f| require f }