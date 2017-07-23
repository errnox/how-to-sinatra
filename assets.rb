require 'sinatra/base'
require 'sprockets'
require 'compass'
require 'yui/compressor'


class Assets < Sinatra::Base
  configure do
    environment = Sprockets::Environment.new do |env|
      env.append_path(settings.root + '/assets/images')
      env.append_path(settings.root + '/assets/javascripts')
      env.append_path(settings.root + '/assets/stylesheets')
      env.append_path "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"

      if ENV['RACK_ENV'] == 'production'
        env.js_compressor = YUI::JavaScriptCompressor.new
        env.css_compressor = YUI::CssCompressor.new
      end
    end
    set :assets, environment
  end

  get '/assets/app.js' do
    content_type('application/javascript')
    settings.assets['app.js']
  end

  get '/assets/app.css' do
    content_type('text/css')
    settings.assets['screen.css']
  end

  %w(jpg png).each do |format|
    get "/assets/:image.#{format}" do |image|
      content_type 'image/#{format}'
      settings.assets["#{image}.#{format}"]
    end
  end
end
