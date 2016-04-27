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

conn.exec("DROP TABLE IF EXISTS comments")
conn.exec("DROP TABLE IF EXISTS restaurants")
conn.exec("DROP TABLE IF EXISTS users")

conn.exec("CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  email VARCHAR NOT NULL
)")

conn.exec("CREATE TABLE restaurants(
  id SERIAL PRIMARY KEY,
  restaurant_name VARCHAR(255) NOT NULL,
  menu_item VARCHAR(255) NOT NULL,
  review TEXT NOT NULL,
  user_id INTEGER REFERENCES users(id)
)")

conn.exec("CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  comment TEXT NOT NULL,
  restaurant_id INTEGER REFERENCES restaurants(id),
  user_id INTEGER REFERENCES users(id)
  )")

conn.exec_params("INSERT INTO users (username, email) VALUES (
    $1,$2)", ['alliesauce', 'alli.cummings@gmail.com'])

conn.exec_params("INSERT INTO restaurants (restaurant_name, menu_item, review, user_id) VALUES ($1,$2,$3,$4)", ['La Pecora Bianca', 'Toscana Salad', 'real restaurant quality salad, great flavors, good if you love kale, but definitely a lighter meal',    1])
