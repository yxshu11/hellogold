puts "Creating Countries"
Country.find_or_create_by(name: "Malaysia", currency_code: "MYR")
Country.find_or_create_by(name: "Singapore", currency_code: "SGD")
Country.find_or_create_by(name: "Thailand", currency_code: "THB")

puts "Creating User"
User.create(email: "admin@email.com", password: "111111", password_confirmation: "111111", first_name: "HelloGold", last_name: "Admin", is_admin: true, country_id: 1)
User.create(email: "john.doe@email.com", password: "111111", password_confirmation: "111111", first_name: "John", last_name: "Doe", country_id: 1)

puts "Creating Asset"

puts "Creating Transactions"

puts "Done"
