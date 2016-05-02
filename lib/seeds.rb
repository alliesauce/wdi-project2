require 'bundler/setup'
require 'pg'
require 'pry'
require 'faker'

if ENV["RACK_ENV"] == "production"
  conn = PG.connect(
      dbname: ENV["POSTGRES_DB"], #ENV masks your variables for protection
      host: ENV["POSTGRES_HOST"],
      password: ENV["POSTGRES_PASS"],
      user: ENV["POSTGRES_USER"]
    )
else
  conn = PG.connect(dbname: "mealpass_reviews")
end

conn.exec("DROP TABLE IF EXISTS contact_data")
conn.exec("DROP TABLE IF EXISTS comments CASCADE")
conn.exec("DROP TABLE IF EXISTS restaurants CASCADE")
conn.exec("DROP TABLE IF EXISTS tags CASCADE")
conn.exec("DROP TABLE IF EXISTS users CASCADE")

conn.exec("CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  fname VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR NOT NULL,
  password VARCHAR NOT NULL
)")

conn.exec("CREATE TABLE tags(
  id SERIAL PRIMARY KEY,
  tag VARCHAR(255) NOT NULL
)")

conn.exec("CREATE TABLE restaurants(
  id SERIAL PRIMARY KEY,
  restaurant_name VARCHAR(255) NOT NULL,
  menu_item VARCHAR(255) NOT NULL,
  review TEXT NOT NULL,
  likes INTEGER NOT NULL DEFAULT 0,
  user_id INTEGER REFERENCES users(id),
  user_fname TEXT REFERENCES users(fname),
  tag_id INTEGER REFERENCES tags(id)
)")

conn.exec("CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  comment TEXT NOT NULL,
  restaurant_id INTEGER REFERENCES restaurants(id),
  user_id INTEGER REFERENCES users(id),
  user_fname TEXT REFERENCES users(fname)
  )")

conn.exec("CREATE TABLE contact_data(
    id SERIAL PRIMARY KEY,
    fname VARCHAR(255),
    lname VARCHAR(255),
    email VARCHAR(255),
    message TEXT NOT NULL
  )"
)


#TEST DATA
# conn.exec_params("INSERT INTO users (fname, email, password) VALUES (
# #     $1,$2,$3)", ['Alli', 'alli.cummings@gmail.com', 'p@ssword'])

# conn.exec_params("INSERT INTO restaurants (restaurant_name, menu_item, review, user_id) VALUES ($1,$2,$3,$4)", ['La Pecora Bianca', 'Toscana Salad', 'real restaurant quality salad, great flavors, good if you love kale, but definitely a lighter meal',    1])
#################

tags = [
  'healthy',
  'light',
  'hangover helper',
  'heavy',
  'vegetarian',
  'avoid',
  'not worth the walk',
  'not enough food',
  'meat sweats'
  ]

tags.each do |tag|
  conn.exec_params("INSERT INTO tags (tag) VALUES ($1)", [tag])
end
