# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'
csv_text = File.read(Rails.root.join('lib', 'seeds', 'insurance.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  i = Insurance.new
  i.age = row['age']
  i.sex = row['sex']
  i.bmi = row['bmi']
  i.children = row['children']
  i.smoker = row['smoker']
  i.region = row['region']
  i.charges = row['charges']
  i.save
  puts "#{i.age}, #{i.sex} saved"
end

puts "There are now #{Insurance.count} rows in the insurances table"