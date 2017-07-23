require_relative 'app'
require_relative 'assets'
require_relative 'sinatra/stats'

use SuperApp::App
# use Assets

# run Sinatra::Application
run SuperApp::App.new
