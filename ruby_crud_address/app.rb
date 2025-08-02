# app.rb
require 'sinatra'
require 'sequel'
require 'json'
require 'sinatra/cross_origin'

configure do
  enable :cross_origin
end

# Connect to SQLite
DB = Sequel.sqlite('address_book.db')
people = DB[:people]

before do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
end

# CORS preflight support
options "*" do
  response.headers["Allow"] = "GET, POST, PUT, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type"
  response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
  200
end

# Get all people
get '/people' do
  people.all.to_json
end

# Get one person
get '/people/:id' do
  person = people.where(id: params[:id]).first
  halt 404, { error: "Not found" }.to_json unless person
  person.to_json
end

# Add person
post '/people' do
  data = JSON.parse(request.body.read)
  id = people.insert(
    name: data["name"],
    email: data["email"],
    address: data["address"],
    street: data["street"],
    house_number: data["house_number"]
  )
  people.where(id: id).first.to_json
end

# Update
put '/people/:id' do
  data = JSON.parse(request.body.read)
  updated = people.where(id: params[:id]).update(
    name: data["name"],
    email: data["email"],
    address: data["address"],
    street: data["street"],
    house_number: data["house_number"]
  )
  halt 404, { error: "Not found" }.to_json if updated == 0
  people.where(id: params[:id]).first.to_json
end

# Delete
delete '/people/:id' do
  deleted = people.where(id: params[:id]).delete
  halt 404, { error: "Not found" }.to_json if deleted == 0
  { message: "Deleted" }.to_json
end
