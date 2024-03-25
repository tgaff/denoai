# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def apply_texts(lib, texts)
  texts.each do |text_def|
    txt = lib.texts.find_or_create_by(name: text_def[:name])
    txt.source_type = 'txt'
    txt.content = File.read(Rails.root.join('db', 'seeds', text_def[:file]))
    txt.save
  end
end

# temporary renames - renaming rather than recreating to save on credits ha
def rename_lib(from:, to:)
  lib = Library.find_by(name: from)
  return true unless lib
  lib.name = to
  lib.save!    
end
rename_lib(from: 'test - company', to: "Vartend Heavy Industries")
rename_lib(from: 'test - Two Rivers', to: "Two Rivers")
rename_lib(from: 'lz', to: "LZ")


lib = Library.find_or_create_by(name: "Vartend Heavy Industries")

test_texts = [
  {name: "Employee Handbook", file: "emp_handbook.txt"},
  {name: "Employee Health Plan", file: "emp_health_plan.txt"},
  {name: "About Company", file: "vhi_about.txt"},
]

apply_texts(lib, test_texts)

puts "Number of text records for test: [#{lib.texts.count}]"
puts "Total text records: [#{Text.count}]"

lib = Library.find_or_create_by(name: "Two Rivers")

test_texts = [
  {name: "Farming", file: "2rivers_farming.txt"},
  {name: "Old Oak Wines", file: "2rivers_old_oak_wines.txt"},
  {name: "Leather", file: "2rivers_leather.txt"}
]

apply_texts(lib, test_texts)

puts "Number of text records for test: [#{lib.texts.count}]"
puts "Total text records: [#{Text.count}]"
