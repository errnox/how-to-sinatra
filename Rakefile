require 'compass'
require 'sinatra/asset_pipeline/task'
require 'sinatra/activerecord/rake'

require_relative './app'

# Asset pipeline
#
# Precompiling assets works like this:
#   RACK_ENV=production rake assets:precompile
# Clearing old compiled assets:
#   RACK_ENV=production rake assets:clean
Sinatra::AssetPipeline::Task.define! App
