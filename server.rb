module Sinatra
  require 'bcrypt'
  require 'pry'
  require 'redcarpet'

  class Server < Sinatra::Base
    enable :sessions
    include BCrypt

    #SESSION CODE
    #help with login code from https://wixelhq.com/blog/working-with-sinatra-routes-and-conditions
    def logged_in?
      !session[:user_id].nil?
    end

    def current_user
      @current_user = conn.exec_params(
        "SELECT * FROM users WHERE id=$1 LIMIT 1",
        [session[:user_id]]
      ).first
    end

    #MARKDOWN - not working yet
    def markdown
      renderer = Redcarpet::Render::HTML
      # Initializes a Markdown parser
      markdown = Redcarpet::Markdown.new(renderer, extensions = {})
      @content = markdown.render(@article["content"])
    end

    #VIEW LANDING PAGE, same as signup page
    get "/" do
      erb :signup
    end

    #VIEW CONTACT PAGE
    get "/contact" do
      erb :contact
    end

    #VIEW SIGNUP PAGE
    get "/signup" do
      erb :signup
    end

    #VIEW LOGIN PAGE
    get "/login" do
      if logged_in?
        erb :dashboard
      else
        erb :login
      end
    end

    #VIEW DASHBOARD PAGE (list of restaurants("topics") and form to submit new restaurant)
    get "/dashboard" do
      @id = params[:id].to_i
      @restaurants = conn.exec('SELECT * FROM restaurants')
      if logged_in?
        erb :dashboard
       binding pry
      else
        erb :login
      end
    end

    #VIEW REVIEW PAGE (specific restaurant page and form to submit comment)
    get "/review/:id" do
      @id = params[:id].to_i
      @restaurant = conn.exec("SELECT * FROM restaurants WHERE id = #{@id}")
      @comments = conn.exec("SELECT * FROM comments WHERE restaurant_id = #{@id}")
      @restaurant_id = @restaurant.to_a[0]['id'].to_i
      if logged_in?
        erb :restaurant
      else
        erb :login
      end
    end

    #SUBMITTING SIGNUP INFORMATION
    post "/signup" do
      @fname = params[:fname]
      @email = params[:email]
      @encrPassword = BCrypt::Password.create(params[:password])
      #add image/avatar thing??
      conn.exec_params(
        "INSERT INTO users (fname, email, password) VALUES ($1,$2,$3) RETURNING id", [@fname, @email, @encrPassword])
      redirect "/dashboard"
    end

    #SUBMITTING LOGIN DETAILS
    post "/login" do
      @email = params[:email]
      @password = params[:password]
      @user = conn.exec_params(
        "SELECT * FROM users WHERE email=$1 LIMIT 1",
        [@email]
      ).first
      if @user && BCrypt::Password::new(@user["password"]) == params[:password]
        "You have successfully logged in."
        session[:user_id] = @user["id"]
        redirect "/dashboard"
      else
        "Incorrect email or password!"
      end
    end

    #SUBMITTING A NEW RESTAURANT (review or "topic")
    post "/review" do
      @restaurant_name = params[:restaurant_name]
      @menu_item = params[:menu_item]
      @review = params[:review]
      # @user_id = params[:user_id].to_i
      # @tag_id = params[:tag_id].to_i
      conn.exec_params(
        "INSERT INTO restaurants (restaurant_name, menu_item, review)
        VALUES ($1, $2, $3)",
        [@restaurant_name, @menu_item, @review])
      redirect "/dashboard"
    end

    #SUBMITTING A COMMENT ON A RESTAURANT
    post "/comment" do
      @comment = params[:comment]
      @restaurant_id = params[:restaurant_id].to_i
      # @user_id = params[:user_id].to_i
      conn.exec_params(
        "INSERT INTO comments (comment, restaurant_id) VALUES ($1, $2) RETURNING id", [@comment, @restaurant_id])
    end

    #SUBMITTING A CONTACT REQUEST
    post "/contact" do
      @fname = params[:fname]
      @lname = params[:lname]
      @email = params[:email]
      @message = params[:message]

      conn.exec_params("INSERT INTO contact_data (fname, lname, email, message) VALUES ($1,$2,$3, $4)", [@fname, @lname, @email, @message])

      @submitted = true

      erb :contact
    end

    #LIKING, or upvoting, a restaurant ("topic")
    post "/like" do
      "hello world"
      @likes = params[:likes].to_i
      @restaurant_id = params[:restaurant_id].to_i
      conn.exec("UPDATE restaurants SET likes = likes + 1 WHERE restaurant_id = #{@restaurant_id}")
      rediect "/review/:id"
    end

    #UNDEFINED ROUTES
    put "/review/:id" do
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
    ###############

    #CODE TO CONNECT TO DATABASE
    private

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
