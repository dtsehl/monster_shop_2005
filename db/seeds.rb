# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

# Users
admin = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret', role: 2)
merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1)

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

bike_pump = bike_shop.items.create(name: "Bike Pump", description: "To pump it up!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/615GENPCD5L._AC_SX425_.jpg", inventory: 15)
bike_chain = bike_shop.items.create(name: "Bike Chain", description: "Better chainz!", price: 75, image: "https://images-na.ssl-images-amazon.com/images/I/51cafKW0NgL._AC_.jpg", inventory: 75)
bike_tool = bike_shop.items.create(name: "Bike Tool", description: "Make it tight!", price: 30, image: "https://www.rei.com/media/product/718804", inventory: 100)

kong = dog_shop.items.create(name: "Kong", description: "Tasty treat!", price: 10, image: "https://images-na.ssl-images-amazon.com/images/I/719dcnCnHfL._AC_SL1500_.jpg", inventory: 50)
bed = dog_shop.items.create(name: "Dog Bed", description: "Sleepy time!", price: 21, image: "https://images-na.ssl-images-amazon.com/images/I/71IvYiQYcAL._AC_SY450_.jpg", inventory: 40)

order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
order_2 = Order.create!(name: 'Yo', address: 'Whatever', city: 'Place', state: 'PA', zip: 17033)
order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 4)
order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3)
order_1.item_orders.create!(item: tire, price: tire.price, quantity: 6)
order_2.item_orders.create!(item: bed, price: bed.price, quantity: 5)
order_1.item_orders.create!(item: kong, price: kong.price, quantity: 4)
order_1.item_orders.create!(item: bike_tool, price: bike_tool.price, quantity: 3)
order_2.item_orders.create!(item: bike_chain, price: bike_chain.price, quantity: 2)
order_2.item_orders.create!(item: bike_pump, price: bike_pump.price, quantity: 1)
