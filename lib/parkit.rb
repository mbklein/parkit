require 'sinatra'
require 'sequel'

# db.create_table :parked do
#   primary_key :id
#   String :user_id
#   String :url
# end

class ParkItApp < Sinatra::Base

  configure do
    set(:app_root, File.join(File.dirname("__FILE__"),".."))
    db = Sequel.connect(ENV['DATABASE_URL'] || "sqlite://db/#{settings.environment.to_s}.sqlite3")
    set(:db, db[:urls])
  end

  before do
    # single user. for now.
    @user_id = 'mbklein'
  end

  helpers do
    def clear
      settings.db.where(:user_id => @user_id).delete
    end
  end
  
  get '/clear' do
    clear
    redirect to('/setup')
  end
  
  get '/park' do
    clear
    settings.db.insert(:user_id => @user_id, :url => params[:url])
    status 204
  end

  get '/pickup' do
    row = settings.db.where(:user_id => @user_id).first
    if row.nil?
      halt 404
    else
      redirect row[:url], 302
    end
  end

  get '/setup' do
    @bkmklt = %{javascript:function%20prkit()%20{var%20d%20=%20document,z%20=%20d.createElement(%27scr%27%20+%20%27ipt%27),b%20=%20d.body,l%20=%20d.location;try%20{if%20(!b)%20throw%20(0);z.setAttribute(%27src%27,%20l.protocol%20+%20%27//#{request.host_with_port}/park?url=%27%20+%20encodeURIComponent(l.href)%20+%20%27&t=%27%20+%20(new%20Date().getTime()));b.appendChild(z);}%20catch(e)%20{alert(%27Please%20wait%20until%20the%20page%20has%20loaded.%27);}}prkit();void(0)}
    @pickup = %{http://#{request.host_with_port}/pickup}
    haml :setup
  end
  
end