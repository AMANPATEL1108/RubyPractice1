# db_setup.rb
require 'sequel'

DB = Sequel.sqlite('address_book.db')

DB.create_table? :people do
  primary_key :id
  String :name
  String :email
  String :address
  String :street
  String :house_number
end
