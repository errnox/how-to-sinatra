module SuperApp
  class App < Sinatra::Base
    nnamespace '/api' do
      nnamespace '/new' do
        gget '/c*o*l*o*r*/:name/:value/?' => :show_color, :as =>
          :color, :mask => '/color/:name/:value'
      end
    end

    nnamespace '/api' do
      gget '/b*l*u*e*/:name/:value/?' => :blue, :as => :blue, :mask =>
        '/blue/:name/:value', :prefix => '/important'
      ppost '/b*l*u*e*/:name/:value/?' => :post_blue, :as =>
        :blue, :mask => '/blue/:name/:value', :prefix => '/important'
    end

    gget '/s*o*m*e*t*h*i*n*g*/:name/:value/?' => :api_something, :as =>
      :something, :mask => '/something/:name/:value'

    def blue
      request.path
    end

    def post_blue
      params.inspect
    end

    def show_color
      "COLOR"
    end

    require 'pp'
    pp settings.app_paths
  end
end
