require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    # it "all items or merchant names are links" do
    #   visit '/items'
    #
    #   expect(page).to have_link(@tire.name)
    #   expect(page).to have_link(@tire.merchant.name)
    #   expect(page).to have_link(@pull_toy.name)
    #   expect(page).to have_link(@pull_toy.merchant.name)
    # end
    #
    # it "I can see a list of all of the items "do
    #
    #   visit '/items'
    #
    #   within "#item-#{@tire.id}" do
    #     expect(page).to have_link(@tire.name)
    #     expect(page).to have_content(@tire.description)
    #     expect(page).to have_content("Price: $#{@tire.price}")
    #     expect(page).to have_content("Inventory: #{@tire.inventory}")
    #     expect(page).to have_link(@meg.name)
    #     expect(page).to have_css("img[src*='#{@tire.image}']")
    #   end
    #
    #   within "#item-#{@pull_toy.id}" do
    #     expect(page).to have_link(@pull_toy.name)
    #     expect(page).to have_content(@pull_toy.description)
    #     expect(page).to have_content("Price: $#{@pull_toy.price}")
    #     expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
    #     expect(page).to have_link(@brian.name)
    #     expect(page).to have_css("img[src*='#{@pull_toy.image}']")
    #   end
    # end
    #
    # it 'does not display items that are inactive, and item images are links to the item show page' do
    #   visit '/items'
    #
    #   expect(page).to have_content(@tire.name)
    #   expect(page).to have_content(@pull_toy.name)
    #   expect(page).to_not have_content(@dog_bone.name)
    #
    #   find("#item-#{@tire.id}-img").click
    #
    #   expect(current_path).to eq("/items/#{@tire.id}")
    # end

    it 'shows an area with statistics' do
       bike_pump = @meg.items.create(name: "Bike Pump", description: "To pump it up!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/615GENPCD5L._AC_SX425_.jpg", inventory: 15)
       bike_chain = @meg.items.create(name: "Bike Chain", description: "Better chainz!", price: 75, image: "https://images-na.ssl-images-amazon.com/images/I/51cafKW0NgL._AC_.jpg", inventory: 75)
       bike_tool = @meg.items.create(name: "Bike Tool", description: "Make it tight!", price: 30, image: "https://www.rei.com/media/product/718804", inventory: 100)

       kong = @brian.items.create(name: "Kong", description: "Tasty treat!", price: 10, image: "https://images-na.ssl-images-amazon.com/images/I/719dcnCnHfL._AC_SL1500_.jpg", inventory: 50)
       bed = @brian.items.create(name: "Dog Bed", description: "Sleepy time!", price: 21, image: "https://images-na.ssl-images-amazon.com/images/I/71IvYiQYcAL._AC_SY450_.jpg", inventory: 40)

       order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
       order_2 = Order.create!(name: 'Yo', address: 'Whatever', city: 'Place', state: 'PA', zip: 17033)

       order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 4)
       order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
       order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 6)
       order_2.item_orders.create!(item: bed, price: bed.price, quantity: 5)
       order_1.item_orders.create!(item: kong, price: kong.price, quantity: 4)
       order_1.item_orders.create!(item: bike_tool, price: bike_tool.price, quantity: 3)
       order_2.item_orders.create!(item: bike_chain, price: bike_chain.price, quantity: 2)
       order_2.item_orders.create!(item: bike_pump, price: bike_pump.price, quantity: 1)

      visit '/items'
      save_and_open_page
      expect(page).to have_content("Statistics")
      within ".statistics-top-5" do
        expect(page.all('li')[0]).to have_content("#{@pull_toy.name}")
        expect(page.all('li')[1]).to have_content("#{@tire.name}")
        expect(page.all('li')[2]).to have_content("#{bed.name}")
        expect(page.all('li')[3]).to have_content("#{kong.name}")
        expect(page.all('li')[4]).to have_content("#{bike_tool.name}")

        expect(page).to have_content("#{@pull_toy.name}: 7")
      end
      within ".statistics-bottom-5" do
        expect(page.all('li')[0]).to have_content("#{bike_pump.name}")
        expect(page.all('li')[1]).to have_content("#{bike_chain.name}")
        expect(page.all('li')[2]).to have_content("#{bike_tool.name}")
        expect(page.all('li')[3]).to have_content("#{kong.name}")
        expect(page.all('li')[4]).to have_content("#{bed.name}")

        expect(page).to have_content("#{kong.name}: 4")
      end
    end
  end
end
