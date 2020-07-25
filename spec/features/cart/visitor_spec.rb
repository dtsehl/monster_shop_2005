require 'rails_helper'

RSpec.describe 'Cart show page' do
  it 'requires visitor to register or log in before checking out' do
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{pencil.id}"
    click_on "Add To Cart"

    visit '/cart'
    expect(page).to have_content('You must register or log in to checkout!')
    expect(page).to have_link('register')
    expect(page).to have_link('log in')
    expect(page).to_not have_link('Checkout')

    click_link 'register'
    expect(current_path).to eq('/register')

    visit '/cart'

    click_link 'log in'
    expect(current_path).to eq('/login')
  end
end
