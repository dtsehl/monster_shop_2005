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

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end
    end

    it 'does not display items that are inactive, and item images are links to the item show page' do
      visit '/items'

      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@pull_toy.name)
      expect(page).to_not have_content(@dog_bone.name)

      find("#item-#{@tire.id}-img").click

      expect(current_path).to eq("/items/#{@tire.id}")
    end

    it 'shows an area with statistics' do
       bike_pump = @meg.items.create(name: "Bike Pump", description: "To pump it up!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/615GENPCD5L._AC_SX425_.jpg", inventory: 15)
       bike_chain = @meg.items.create(name: "Bike Chain", description: "Better chainz!", price: 75, image: "https://images-na.ssl-images-amazon.com/images/I/51cafKW0NgL._AC_.jpg", inventory: 75)
       bike_tool = @meg.items.create(name: "Bike Tool", description: "Make it tight!", price: 30, image: "https://www.rei.com/media/product/718804", inventory: 100)

       kong = @brian.items.create(name: "Kong", description: "Tasty treat!", price: 10, image: "https://images-na.ssl-images-amazon.com/images/I/719dcnCnHfL._AC_SL1500_.jpg", inventory: 50)
       bed = @brian.items.create(name: "Dog Bed", description: "Sleepy time!", price: 21, image: "https://images-na.ssl-images-amazon.com/images/I/71IvYiQYcAL._AC_SY450_.jpg", inventory: 40)

       name = "Bert"
       address = "123 Sesame St."
       city = "NYC"
       state = "New York"
       zip = 10001

      8.times do
        visit "/items/#{@dog_bone.id}"
        click_on "Add To Cart"
      end
      7.times do
        visit "/items/#{@pull_toy.id}"
        click_on "Add To Cart"
      end
      6.times do
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
      end
      5.times do
        visit "/items/#{bed.id}"
        click_on "Add To Cart"
      end
      4.times do
        visit "/items/#{kong.id}"
        click_on "Add To Cart"
      end
      3.times do
        visit "/items/#{bike_tool.id}"
        click_on "Add To Cart"
      end
      2.times do
        visit "/items/#{bike_chain.id}"
        click_on "Add To Cart"
      end
      visit "/items/#{bike_pump.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      visit '/items'
      expect(page).to have_content("Statistics")
      within ".statistics-top-5" do
        expect(@dog_bone).to appear_before(@pull_toy)
        expect(@pull_toy).to appear_before(@tire)
        expect(@tire).to appear_before(bed)
        expect(bed).to appear_before(kong)
        expect(page).to have_content("#{@dog_bone.name}: 8")
      end
      within ".statistics-bottom-5" do
        expect(bike_pump).to appear_before(bike_chain)
        expect(bike_chain).to appear_before(bike_tool)
        expect(bike_tool).to appear_before(kong)
        expect(kong).to appear_before(bed)
        expect(page).to have_content("#{kong.name}: 4")
      end
    end
  end
end
