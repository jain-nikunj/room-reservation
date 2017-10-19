# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'csv'


csv_text = File.read(Rails.root.join('lib', 'seeds', 'buildings.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = Building.new
  t.name = row['name']
  t.misc = row['misc']
  t.save
  puts "#{t.name}, #{t.misc} saved"
end

puts "There are now #{Building.count} rows in the Building table"

csv_text = File.read(Rails.root.join('lib', 'seeds', 'rooms_south.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = Room.new
  t.building_id = Building.where("name = :name", {name: row['building']})[0].id
  t.number = row['number']
  t.capacity = row['capacity']
  t.facilities = row['facilities']
  t.misc = row['misc']
  t.save
  puts "#{t.building_id}, #{t.capacity} saved"
end

puts "There are now #{Room.count} rows in the Room table"

csv_text = File.read(Rails.root.join('lib', 'seeds', 'rooms_west.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = Room.new
  t.building_id = Building.where("name = :name", {name: row['Location']})[0].id
  t.number = row['Room']
  t.capacity = row['Max Capacity']
  t.facilities = row['Features']
  t.misc = row['Categories']
  t.save
  puts "#{t.building_id}, #{t.capacity} saved"
end

puts "There are now #{Room.count} rows in the Room table"