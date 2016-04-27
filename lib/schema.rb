#DONT NEED THIS RIGHT NOW


# def conn
#   if ENV["RACK_ENV"] == "production"
#     PG.connect(
#       dbname: ENV["POSTGRES_DB"], #ENV masks your variables for protection
#       host: ENV["POSTGRES_HOST"],
#       password: ENV["POSTGRES_PASS"],
#       user: ENV["POSTGRES_USER"]
#     )
#   else
#     PG.connect(dbname: "mealpass_reviews")
#   end
# end #end def conn

# conn.exec("DROP TABLE IF EXISTS restaurants")
# conn.exec("CREATE TABLE #{restaurants}(
#   id SERIAL PRIMARY KEY,
#   restaurant_name VARCHAR(255) NOT NULL,
#   menu_item VARCHAR(255) NOT NULL,
#   review TEXT NOT NULL,
#   username VARCHAR(255) REFERENCES users(username)
# )")

# conn.exec("DROP TABLE IF EXISTS #{users}")
# conn.exec("CREATE TABLE #{users}(
#   id SERIAL PRIMARY KEY,
#   username VARCHAR(255) NOT NULL,
#   email VARCHAR NOT NULL,
# )")

# conn.exec("DROP TABLE IF EXISTS #{comments}")
# conn.exec("CREATE TABLE #{comments}(
#   id SERIAL PRIMARY KEY,
#   comment TEXT NOT NULL,
#   restaurant_id INTEGER REFERENCES restaurants(id)
#   username VARCHAR(255) REFERENCES users(username)
#   )")
