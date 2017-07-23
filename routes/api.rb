module SuperApp
  class App < Sinatra::Base
    # nnamespace '/api' do
    #   nnamespace '/old' do
    #     gget '/s*o*m*e*t*h*i*n*g*/:name/:value/?' => :something, :as =>
    #       :something, :mask => '/something/:name/:value'
    #   end
    # end

    def api_something
      "#{request.path} - Name: #{params[:name]} - Description: \
#{params[:description]}"
    end

    get mmap('/r*o*u*t*e*/:name/?', '/route/:name', :route) do
      "Route: #{request.path}"
    end
  end
end
