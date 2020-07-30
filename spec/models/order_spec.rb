require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it { should have_many :item_orders }
    it { should have_many(:items).through(:item_orders) }
    it { should have_many :user_orders }
    it { should have_many(:users).through(:user_orders) }
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it '#grand_total' do
      expect(@order_1.grand_total).to eq(230)
    end

    it "calculates total merchant quantity" do
      expect(@order_1.total_merchant_quantity(@brian.id)).to eq(3)
    end

    it "calculates total merchant value" do
      expect(@order_1.total_merchant_value(@brian.id)).to eq(30)
    end

    it "merchant_items" do
      merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: @meg.id)
      visit '/login'
      fill_in :email, with: merchant.email
      fill_in :password, with: merchant.password
      click_button "Log In"

      expect(@order_1.merchant_items(@meg.id)).to eq([@tire])
    end
  end

  describe 'class methods' do
    it '.by_status' do
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 'Packaged')
      order_2 = Order.create!(name: 'Yo', address: 'Whatever', city: 'Place', state: 'PA', zip: 17033, status: 'Pending')
      order_3 = Order.create!(name: 'Brian', address: '456 Zanti St', city: 'Denver', state: 'CO', zip: 29834, status: 'Shipped')
      order_4 = Order.create!(name: 'Cory', address: '789 Westerfield Ln', city: 'NYC', state: 'NY', zip: 98713, status: 'Cancelled')

      expect(Order.by_status('Packaged')).to eq([order_1])
      expect(Order.by_status('Pending')).to eq([order_2])
      expect(Order.by_status('Shipped')).to eq([order_3])
      expect(Order.by_status('Cancelled')).to eq([order_4])
    end
  end
end
