require 'bundler/setup'
require 'sinatra'
require './lib/app'
require 'slim'

configure :development do
  require 'rake-pipeline'
  require 'rake-pipeline/middleware'
  use Rake::Pipeline::Middleware, 'Assetfile'
  require 'rack-livereload'
  use Rack::LiveReload
end

map '/' do
  run Sinatra::Application
end
