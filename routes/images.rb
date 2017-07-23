module SuperApp
  class App < Sinatra::Base
    get '/images/:image_name/?' do
      send_file "public/files/#{params[:image_name]}"
    end

    get '/textimage/new/?' do
      @image_name = 'image.png'
      haml 'textimage/new'.to_sym, :layout => :application
    end

    post '/textimage/new/?' do
      @image_name = 'image.png'
      haml 'textimage/new'.to_sym, :layout => :application
    end

    get '/downloads/textimage/?' do
      send_file './public/files/image.png', :filename =>
        'image.png', :type => 'Application/octet-stream'
    end

    post '/images/:image_name/?' do
      image_name = 'image.png'
      image_text = set_default_str(params[:image_text],
                                   'This is an image with text.')
      background_color = set_default_str(params[:background_color],
                                         'black')
      foreground_color = set_default_str(params[:foreground_color],
                                         'black')
      font = set_default_str(params[:font], 'Helvetica')
      font_size = set_default_int(params[:font_size], '23')
      border = (params[:use_padding] =~ // ? 10 : 0)

      # Generate the image using ImageMagick
      `printf "%s" "#{image_text}" | \
convert \
-background #{background_color} \
-fill #{foreground_color} \
-font #{font} \
-pointsize #{font_size} \
-border #{border} \
-bordercolor #{background_color} \
label:@- \
"./public/files/#{image_name}" `

      redirect to('/textimage/new'), 303
    end
  end
end
