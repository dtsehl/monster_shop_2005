require 'rails_helper'

RSpec.describe 'Cart creation' do
  describe 'When I visit an items show page' do

    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    end

    it "I see a link to add this item to my cart" do
      visit "/items/#{@paper.id}"
      expect(page).to have_button("Add To Cart")
    end

    it "I can add this item to my cart" do
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"

      expect(page).to have_content("#{@paper.name} was successfully added to your cart")
      expect(current_path).to eq("/items")

      within 'nav' do
        expect(page).to have_content("Cart: 1")
      end

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      within 'nav' do
        expect(page).to have_content("Cart: 2")
      end
    end

    it "I can increment the quantity of an item in my cart, but not beyond the item's inventory size" do
      eraser = @mike.items.create(name: "Pink Eraser", description: "Great for erasing things!", price: 5, image: "https://upload.wikimedia.org/wikipedia/commons/2/2f/Pink_Pearl_eraser.jpg", inventory: 3)
      visit "/items/#{eraser.id}"
      click_on "Add To Cart"

      visit "/cart"

      within "#cart-item-#{eraser.id}" do
        expect(page).to have_content("1")
        expect(page).to have_button("+")
        click_on "+"
      end

      within "#cart-item-#{eraser.id}" do
        expect(page).to have_content("2")
        expect(page).to have_button("+")
        click_on "+"
      end
      within "#cart-item-#{eraser.id}" do
        expect(page).to have_content("3")
        expect(page).to_not have_button("+")
      end
      within 'nav' do
        expect(page).to have_content("Cart: 3")
      end
    end

    it "I can decrement the quantity of an item in my cart, but not beyond zero" do
      eraser = @mike.items.create(name: "Pink Eraser", description: "Great for erasing things!", price: 5, image: "https://upload.wikimedia.org/wikipedia/commons/2/2f/Pink_Pearl_eraser.jpg", inventory: 3)
      visit "/items/#{eraser.id}"
      click_on "Add To Cart"

      visit "/cart"

      expect(page).to have_content(eraser.name)

      within "#cart-item-#{eraser.id}" do
        expect(page).to have_content("1")
        expect(page).to have_button("-")
        click_on "+"
        click_on "+"
      end

      within "#cart-item-#{eraser.id}" do
        expect(page).to have_content("3")
        expect(page).to have_button("-")
        click_on "-"
      end

      within "#cart-item-#{eraser.id}" do
        expect(page).to have_content("2")
        expect(page).to have_button("-")
        click_on "-"
      end

      within "#cart-item-#{eraser.id}" do
        expect(page).to have_content("1")
        expect(page).to have_button("-")
        click_on "-"
      end

      expect(page).to_not have_content(eraser.name)

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end
end
