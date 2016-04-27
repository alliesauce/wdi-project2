require 'bundler/setup'
require 'pg'
require 'pry'
require 'faker'

conn = PG.connect(dbname: "mealpass_reviews")

table = "reviews"

conn.exec("DROP TABLE IF EXISTS #{table}")
conn.exec("CREATE TABLE #{table}(
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
  )")
