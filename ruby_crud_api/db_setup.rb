# db_setup.rb
require 'sequel'

DB = Sequel.sqlite('crud_app.db')

DB.create_table? :items do
  primary_key :id
  String :name
  String :email
end
