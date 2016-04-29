module Sinatra
  require 'bcrypt'
  require 'pry'
  require 'redcarpet'

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

    get "/contact" do
      erb :contact
    end

    get "/signup" do
      erb :signup
    end

    def markdown
      renderer = Redcarpet::Render::HTML
      # Initializes a Markdown parser
      markdown = Redcarpet::Markdown.new(renderer, extensions = {})
      @content = markdown.render(@article["content"])
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
      @id = params[:id].to_i
      @restaurants = conn.exec('SELECT * FROM restaurants')
      erb :dashboard

    end

    get "/review/:id" do
      @id = params[:id].to_i
      @restaurant = conn.exec("SELECT * FROM restaurants WHERE id = #{@id}")
      @comments = conn.exec("SELECT * FROM comments WHERE restaurant_id = #{@id}")

      @restaurant_id = @restaurant.to_a[0]['id']
      erb :restaurant
    end

    post "/review" do
      @restaurant_name = params[:restaurant_name]
      @menu_item = params[:menu_item]
      @review = params[:review]
      @user_id = params[:user_id].to_i
      @tag_id = params[:tag_id].to_i
      conn.exec_params(
        "INSERT INTO restaurants (restaurant_name, menu_item, review, user_id, tag_id)
        VALUES ($1, $2, $3, $4, $5)",
        [@restaurant_name, @menu_item, @review, @user_id, @tag_id])
      redirect "/dashboard"
    end

    put "/review/:id" do
      erb :index
    end

    post "/comment" do
      @comment = params[:comment]
      @restaurant_id = params[:restaurant_id].to_i
      @user_id = params[:user_id].to_i
      conn.exec_params(
        "INSERT INTO comments (comment, restaurant_id, user_id) VALUES ($1, $2, $3) RETURNING id", [@comment, @restaurant_id, @user_id])

    end

    post "/like" do
      "hello world"
      @likes = params[:likes].to_i
      @restaurant_id = params[:restaurant_id].to_i
      conn.exec("UPDATE restaurants SET likes = likes + 1 WHERE restaurant_id = #{@restaurant_id}")
      rediect "/review/:id"
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
