# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

lib = Library.find_or_create_by(name: "test")

test_texts = [
    {name: "Employee Handbook", file: "emp_handbook.txt"},
    {name: "Employee Health Plan", file: "emp_health_plan.txt"},
    {name: "About Company", file: "vhi_about.txt"},
]

test_texts.each do |text_def|
  txt = lib.texts.find_or_create_by(name: text_def[:name])
  txt.content = File.read(Rails.root.join('db', 'seeds', text_def[:file]))
  txt.save
end


puts "Number of text records for test: [#{lib.texts.count}]"
puts "Total text records: [#{Text.count}]"