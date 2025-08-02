# app.rb
require 'sinatra'
require 'sequel'
require 'json'
require 'sinatra/cross_origin'

configure do
  enable :cross_origin
end

before do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
end

# CORS preflight
options "*" do
  response.headers["Allow"] = "HEAD,GET,POST,PUT,PATCH,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization, Accept"
  response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
  200
end

# Connect to SQLite DB
DB = Sequel.sqlite('crud_app.db')
items = DB[:items]

# Routes
get '/items' do
  items.all.to_json
end

get '/items/:id' do
  item = items.where(id: params[:id]).first
  halt 404, { error: "Item not found" }.to_json unless item
  item.to_json
end

post '/items' do
  data = JSON.parse(request.body.read)
  id = items.insert(name: data["name"], email: data["email"])
  items.where(id: id).first.to_json
end

put '/items/:id' do
  data = JSON.parse(request.body.read)
  updated = items.where(id: params[:id]).update(name: data["name"], email: data["email"])
  halt 404, { error: "Item not found" }.to_json if updated == 0
  items.where(id: params[:id]).first.to_json
end

delete '/items/:id' do
  deleted = items.where(id: params[:id]).delete
  halt 404, { error: "Item not found" }.to_json if deleted == 0
  { message: "Item deleted" }.to_json
end
