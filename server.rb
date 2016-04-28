module Sinatra
  class Server < Sinatra::Base
    get "/" do
      erb :index
    end

    get "/signup" do
      erb :signup
    end

    post "/signup" do
      username = params[:username]
      email = params[:email]
      encrPassword = BCrypt::Password.create(params[:password])
      #add image/avatar thing??
      @user = db.exec_params("INSERT INTO users (username, email, encrPassword) VALUES ($1,$2,$3) RETURNING id", [username, email, encrPassword])
      redirect "/dashboard"
    end

    get "/login" do
      erb :login
    end

    post "/login" do
      erb :login
    end



    get "/dashboard" do
      @id = params[:id]
      @restaurants = conn.exec('SELECT * FROM restaurants')
      erb :dashboard
    end

    get "/review/:id" do
      erb :index
    end

    post "/review" do
      erb :index
    end

    put "/review/:id" do
      erb :index
    end

    post "/comment" do
      erb :index
    end

    put "/comment/:id" do
      erb :index
    end

    get "profile/:id" do
      erb :index
    end

    put "profile/:id" do
      erb :index
    end

    delete "/review/:id" do
      erb :index
    end

    delete "/comment/:id" do
      erb :index
    end

    def conn
      if ENV["RACK_ENV"] == "production"
        PG.connect(
          dbname: ENV["POSTGRES_DB"], #ENV masks your variables for protection
          host: ENV["POSTGRES_HOST"],
          password: ENV["POSTGRES_PASS"],
          user: ENV["POSTGRES_USER"]
        )
      else
        PG.connect(dbname: "mealpass_reviews")
      end
    end #end def conn
  end #end class Server
end #end module Sinatra
