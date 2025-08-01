# db_connect.rb
require 'sequel'

# Replace with your actual MySQL credentials
DB = Sequel.connect(
  adapter: 'mysql2',
  user: 'root',
  password: 'your_password',
  host: 'localhost',
  database: 'test_db'
)

# Create a table if it doesn't exist
DB.create_table? :users do
  primary_key :id
  String :name
  Integer :age
end

# Insert a record
DB[:users].insert(name: 'John', age: 25)

# Query the table
DB[:users].each do |user|
  puts "#{user[:name]} is #{user[:age]} years old"
end
