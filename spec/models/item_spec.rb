require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    # it { should validate_inclusion_of(:active?).in_array([true,false]) }
    it "should default to active" do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      expect(@chain.active?).to eq(true)
    end
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'quantity ordered' do
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = Order.create!(name: 'Yo', address: 'Whatever', city: 'Place', state: 'PA', zip: 17033)
      order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 4)
      order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3)
      expect(pull_toy.quantity_ordered(pull_toy.id)).to eq(7)
    end

    it 'never ordered?' do
      dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)
      pull_toy = dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 4)

      expect(dog_bone.never_ordered?).to eq(true)
      expect(pull_toy.never_ordered?).to eq(false)
    end
  end

  describe 'class methods' do
    it '.top_five' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      bike_pump = meg.items.create(name: "Bike Pump", description: "To pump it up!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/615GENPCD5L._AC_SX425_.jpg", inventory: 15)
      bike_chain = meg.items.create(name: "Bike Chain", description: "Better chainz!", price: 75, image: "https://images-na.ssl-images-amazon.com/images/I/51cafKW0NgL._AC_.jpg", inventory: 75)
      bike_tool = meg.items.create(name: "Bike Tool", description: "Make it tight!", price: 30, image: "https://www.rei.com/media/product/718804", inventory: 100)
      kong = brian.items.create(name: "Kong", description: "Tasty treat!", price: 10, image: "https://images-na.ssl-images-amazon.com/images/I/719dcnCnHfL._AC_SL1500_.jpg", inventory: 50)
      bed = brian.items.create(name: "Dog Bed", description: "Sleepy time!", price: 21, image: "https://images-na.ssl-images-amazon.com/images/I/71IvYiQYcAL._AC_SY450_.jpg", inventory: 40)
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

      expect(Item.all.top_five).to eq([pull_toy, tire, bed, kong, bike_tool])
    end

    it '.bottom_five' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      bike_pump = meg.items.create(name: "Bike Pump", description: "To pump it up!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/615GENPCD5L._AC_SX425_.jpg", inventory: 15)
      bike_chain = meg.items.create(name: "Bike Chain", description: "Better chainz!", price: 75, image: "https://images-na.ssl-images-amazon.com/images/I/51cafKW0NgL._AC_.jpg", inventory: 75)
      bike_tool = meg.items.create(name: "Bike Tool", description: "Make it tight!", price: 30, image: "https://www.rei.com/media/product/718804", inventory: 100)
      kong = brian.items.create(name: "Kong", description: "Tasty treat!", price: 10, image: "https://images-na.ssl-images-amazon.com/images/I/719dcnCnHfL._AC_SL1500_.jpg", inventory: 50)
      bed = brian.items.create(name: "Dog Bed", description: "Sleepy time!", price: 21, image: "https://images-na.ssl-images-amazon.com/images/I/71IvYiQYcAL._AC_SY450_.jpg", inventory: 40)
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

      expect(Item.all.bottom_five).to eq([bike_pump, bike_chain, bike_tool, kong, bed])
    end
  end
end
