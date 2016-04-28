module Sinatra
  require 'bcrypt'

  class Server < Sinatra::Base
    enable :sessions
    include BCrypt

    def current_user
      @current_user ||= conn.exec_params("SELECT * FROM users WHERE id=$1", [session[:user_id]]).first
    end
##
# def current_user
#     if session["user_id"]
#       @user ||= db.exec_params("SELECT * FROM users WHERE id = $1", [session["user_id"]]).first
#     else
#       {}
#     end
#   end

##
    def logged_in?
      @current_user
    end

    get "/" do
      erb :index
    end

    get "/signup" do
      erb :signup
    end

    post "/signup" do
      @username = params[:username]
      @email = params[:email]
      @encrPassword = BCrypt::Password.create(params[:password])
      #add image/avatar thing??
      conn.exec_params(
        "INSERT INTO users (username, email, password) VALUES ($1,$2,$3) RETURNING id", [@username, @email, @encrPassword])
      redirect "/dashboard"
    end

    get "/login" do
      if logged_in?
        erb :dashboard
      else
        erb :login
      end
    end

    post "/login" do
      @username = params[:username]
      @password = params[:password]

      @user = conn.exec_params("SELECT * FROM users WHERE username=$1 LIMIT 1", [@username]).first

      if @user && BCrypt::Password::new(@user["password"]) == params[:password]
        session[:user_id] = @user["id"]
        redirect "/dashboard"
      else
        #an alert or page that says incorrect try again#
      end
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
