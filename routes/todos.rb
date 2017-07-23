module SuperApp
  class App < Sinatra::Base
    get '/todos/?' do
      @todos = Todo.all.reverse
      haml 'todos/index'.to_sym, :layout => :application
    end

    post '/todo/new/?' do
      name = set_default_str params[:name], ''
      description = set_default_str params[:description], ''
      status = 0
      if name != ''
        todo = Todo.new
        todo.name = name
        todo.description = description
        todo.status = status
        todo.save
      end
      redirect to('/todos'), 303
    end

    post '/todo/new/inline/?' do
      name = set_default_str params[:name], ''
      if name != ''
        todo = Todo.new
        todo.name = name
        todo.description = "Description for Todo: \"#{name}\"\n\n(This \
description is auto-generated.)"
        todo.status = 0
        todo.save
      end
      redirect to(params[:redirect_url]), 303
    end

    get '/todo/:id/?' do
      @todo = Todo.find_by_id params[:id]
      haml 'todos/description'.to_sym, :layout => :application
    end

    get '/todo/edit/:id/?' do
      @todo = Todo.find_by_id params[:id]
      if @todo != nil
        haml 'todos/edit'.to_sym, :layout => :application
      else
        redirect to("/todo/#{params[:id]}")
      end
    end

    get '/todo/delete/:id/?' do
      todo = Todo.find_by_id params[:id]
      todo.destroy unless todo == nil
      redirect to('/todos')
    end

    post '/todo/edit/:id/?' do
      @todo = Todo.find_by_id params[:id]
      if @todo != nil
        name = set_default_str(params[:name], '')
        description = set_default_str(params[:description], '')
        status = (params[:status] =~ // ? 1 : 0)
        if !name.blank?
          @todo.name = name
          @todo.description = description
          @todo.status = status
          @todo.save
          redirect to("/todo/#{params[:id]}"), 303
        else
          redirect to(request.url), 303
        end
      else
        redirect to('/todos'), 303
      end
    end

    post '/todo/toggle/:id/?' do
      todo = Todo.find_by_id params[:id]
      todo.status = (params[:status] =~ // ? 1 : 0)
      todo.save
      puts "---------- #{params[:status]}, #{todo.status}"
      redirect to('/todos'), 303
    end

    post '/todos/done/delete/?' do
      Todo.all.each do |todo|
        if todo.status != 0
          todo.destroy!
        end
      end
      redirect to('/todos/?'), 303
    end

    post '/todos/mark/done/?' do
      Todo.all.each do |todo|
        todo.status = 1
        todo.save
      end
      redirect to('/todos'), 303
    end

    post '/todos/mark/undone/?' do
      Todo.all.each do |todo|
        todo.status = 0
        todo.save
      end
      redirect to('/todos'), 303
    end

    get '/todos/export/json/?' do
      content_type :json
      Todo.all.to_json
    end

    get '/todos/export/ascii/?' do
      ascii = ''
      content_type :text
      Todo.all.each do |todo|
        ascii << "[#{todo.status == 0 ? ' ' : 'x'}] #{todo.name}\n"
      end
      ascii
    end

    get '/todos/export/ascii/long/?' do
      ascii = ''
      content_type :text
      Todo.all.each do |todo|
        ascii << "* #{todo.name}\n"
        ascii << "  [#{todo.status == 0 ? 'not completed' : 'completed'}]\
\n\n"
        todo.description.each_line do |line|
          ascii << "    #{line}"
        end
        ascii << "\n\n"
      end
      ascii
    end

    @@todo_output = '<OUTPUT>'

    get '/todos/eval/?' do
      @output = @@todo_output
      @last_query = session[:last_todo_query]
      haml 'todos/eval'.to_sym, :layout => :application
    end

    post '/todos/eval/?' do
      @@todo_output = eval params[:query]
      session[:last_todo_query] = params[:query]
      redirect to('/todos/eval'), 303
    end
  end
end
