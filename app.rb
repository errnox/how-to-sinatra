require 'sinatra/base'
require 'sinatra/namespace'
require 'haml'
require 'json'
require 'sinatra/asset_pipeline'
require 'sinatra/activerecord'

require_relative 'sinatra/stats'
require_relative 'sinatra/paths'


module SuperApp
  class App < Sinatra::Base
    register Sinatra::AssetPipeline
    register Sinatra::ActiveRecordExtension
    register Sinatra::Namespace

    register Sinatra::Stats
    register Sinatra::Paths

    stats

    # Settings

    configure do
      set :foo, 'FOO'
      set :haml, { :format => :html5, :ugly => true}

      # Session
      set :session_secret, 'super secret'
      enable :sessions

      # ActiveRecord
      # set :database, {:adapter => 'sqlite3', :database => 'db.sqlite3')
      set :database, 'sqlite3:db.sqlite3'

      # Stats
      set :stats_no_html, true
      set :stats_no_stdout, true

      # File uploadsd
      set :uploads_dir, File.expand_path(File.dirname(__FILE__) +
                                         '/uploads')
    end

    # # Paths

    # nnamespace '/api' do
    #   nnamespace '/new' do
    #     gget '/c*o*l*o*r*/:name/:value/?' => :show_color, :as =>
    #       :color, :mask => '/color/:name/:value'
    #   end
    # end

    # nnamespace '/api' do
    #   gget '/b*l*u*e*/:name/:value/?' => :blue, :as => :blue, :mask =>
    #     '/blue/:name/:value', :prefix => '/important'
    #   ppost '/b*l*u*e*/:name/:value/?' => :post_blue, :as => :blue, :mask =>
    #     '/blue/:name/:value', :prefix => '/important'
    # end

    # gget '/s*o*m*e*t*h*i*n*g*/:name/:value/?' => Api.something, :as =>
    #   :something, :mask => '/something/:name/:value'

    # def blue
    #   request.path
    # end

    # def post_blue
    #   params.inspect
    # end

    # def show_color
    #   "COLOR"
    # end

    # require 'pp'
    # pp settings.app_paths

    # App

    #======================================================================
    # Filters
    #======================================================================

    # Before filters

    # before do
    #   puts "-------------------- Status: #{response.status}"
    # end

    # before '/templates/*' do
    #   puts "-------------------- Status (`templates/*`): #{response.status}"
    # end

    # After filters

    # after do
    #   puts "-------------------- Status: #{response.status}"
    # end

    # after '/templates/*' do
    #   puts "-------------------- Status (`templates/*`): #{response.status}"
    # end


    #======================================================================
    # Helpers
    #======================================================================

    module QuickHelpers
      def quick_footer(text = 'Footer')
        template =<<HAMLSTRING
%div.container
  %div.col-md-12
    %hr
    %p.text-center
      #{text}
HAMLSTRING
        Haml::Engine.new(template).render
      end
    end

    helpers QuickHelpers
    helpers Sinatra::Stats


    #======================================================================
    # Stream
    #======================================================================

    class Stream
      def each
        10.times { |i| yield "Stream: #{i}\n" }
      end
    end

    get '/stream/?' do
      Stream.new
      # 'This is working pretty fine.'
    end


    #======================================================================
    # Miscellaneous
    #======================================================================

    get '/?' do
      @is_home = true
      haml :index, :layout => :application
    end

    get '/settings/?' do
      haml :settings, :layout => :application
    end

    get '/number/?:number?' do
      number = params[:number]
      number ? "Here is your number: #{number}." : 'No number'
    end

    get '/foo/?' do
      haml 'foobar/foo.html'.to_sym, :layout => :application
    end

    get '/bar/?' do
      'This is bar.'
    end

    get '/info/?' do
      @special_information = 'NO SPECIAL INFORMATION'
      haml :info, :layout => :application
    end

    get '/json/?' do
      content_type :json
      { :one => 1, :two => 2, :three => [3, 33, 333] }.to_json
    end

    template :inline_template do
      "\
%div.container
  %div.col-md-12
    %h2 Inline Templates
    %p This is an inline template.\
"
    end

    get '/templates/inline/?' do
      haml :inline_template, :layout => :application
    end

    get '/session/?' do
      # Set/Unset session user name.
      @user_name = params[:user_name]
      session[:user_name] = params[:user_name]
      haml :session, :layout => :application
    end

    get '/halt/?' do
      headers 'SOMETHING' => 'This is something.'
      status 500
      halt haml(:halt, :layout => :application)
    end

    get '/stream/custom/?' do
      stream do |out|
        out << 'one\n'
        sleep 0.5
        out << 'two\n'
        sleep 1
        out << 'three\n'
        sleep 2
        out << 'four\n'
      end
    end

    get '/message/?' do
      @message = session[:message] || ''
      session[:message] = ''
      haml :message, :layout => :application
    end

    get '/redirect/?' do
      session[:message] = 'You have just been redirectred successfully.'
      redirect to('/message')
    end

    get '/file/:type/?' do
      if params[:type] == 'txt'
        send_file 'public/files/text.txt'
      elsif params[:type] == 'png'
        send_file 'public/files/image.png'
      end
    end

    get '/useragent/?' do
      session[:message] = request.user_agent
      redirect to('/message')
    end

    get '/cookies/?' do
      session[:message] = request.cookies
      redirect to('/message')
    end

    get '/download/?' do
      send_file 'public/files/text.txt', :filename =>
        'text.txt', :type => 'Application/octet-stream'
    end


    #----------------------------------------------------------------------
    # Stats
    #----------------------------------------------------------------------

    post '/stats/settings/?' do
      # Toggle stats display (statsbar + stdout).
      if params[:stats_no_html] =~ //
        settings.stats_no_html = false
      else
        settings.stats_no_html = true
      end

      if params[:stats_no_stdout] =~ //
        settings.stats_no_stdout = false
      else
        settings.stats_no_stdout = true
      end
      redirect to(params[:request_url]), 303
    end


    #======================================================================
    # 404
    #======================================================================

    # not_found do
    #   status 404
    #   '404 - Not found. Sorry for that.'
    # end
  end
end


require_relative 'helpers/init'
require_relative 'routes/init'
require_relative 'models/init'
require_relative 'routes'
