require_relative '../config/environment'
require "pry"

User.create(name:"Monika",location: "Seattle",contact_num: 23);
User.create(name: "Chandler",location: "Seattle",contact_num: 16);
User.create(name: "joey",location: "Seattle",contact_num: 36);
User.create(name: "Phoebe",location: "Seattle",contact_num: 47);
User.create(name: "Ross",location: "Seattle",contact_num: 37);
User.create(name: "Rachel",location: "Seattle",contact_num: 98);


100.times do 
    Item.create(name: Faker::Food.fruits ,store_id: rand(1..15) , price: Faker::Number.decimal(l_digits: 1, r_digits: 1) )
    Item.create(name: Faker::Food.vegetables ,store_id: rand(1..15) , price: Faker::Number.decimal(l_digits: 1, r_digits: 1) )
    Item.create(name: Faker::Food.ingredient ,store_id: rand(1..15) , price: Faker::Number.decimal(l_digits: 1, r_digits: 1) )
end

15.times do
    User.create(name: Faker::Name.name ,location: ["Seattle", "Tacoma", "Bellevue", "Kent", "Renton", "Redmond"].sample , contact_num:Faker::Number.number(digits: 10))
    Order.create(user_id: rand(1..10), order_date: Time.new)
    Store.create(name: ["Pike Grocery", "Whole Foods Market", "Albertsons", "Saveway Market", "Uwajimaya", "Community Grocery", "Metropolitan Market Queen Anne", "Pike Place Market", "Paris-Madrid Grocery", "QFC", "Amazon Go"].sample, location: ["Seattle", "Tacoma", "Bellevue", "Kent", "Renton", "Redmond"].sample)
end

20.times do
     OrderedItem.create(order_id: rand(1..15), item_id: rand(1..60))
end
