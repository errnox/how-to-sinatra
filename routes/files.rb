module SuperApp
  class App < Sinatra::Base
    get '/files/?' do
      @message = session[:flash] || ''
      session[:flash] = ''
      @files = []
      Dir.foreach(settings.uploads_dir) do |item|
        next if item == '.' or item == '..'
        @files << {:name => item, :content =>
          truncate_keep_newline(File.read(settings.uploads_dir +
                                          '/' + item), 120, "\n...")}
      end
      haml 'files/new'.to_sym, :layout => :application
    end

    get '/files/index/:name' do
      @file = {:name => params[:name], :content =>
        File.read(settings.uploads_dir + '/' + params[:name])}
      haml 'files/index'.to_sym, :layout => :application
    end

    post '/files/upload/?' do
      if params[:files] != nil && params[:files].length > 0
        params[:files].each do |file|
          File.open(settings.uploads_dir + '/' +
                    file[:filename], 'w') do |f|
            f.write(file[:tempfile].read)
          end
        end
        session[:flash] = 'Upload successfull'
      else
        session[:flash] = 'Cannot upload'
      end
      redirect to("/files"), 303
    end

    get '/files/download/:name/?' do
      send_file(settings.uploads_dir + '/' + params[:name])
    end
  end
end
