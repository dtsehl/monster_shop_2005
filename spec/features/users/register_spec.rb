require 'rails_helper'

RSpec.describe 'User registration page' do
  it 'allows a visitor to register as a user' do
    visit '/'

    expect(page).to have_link("Register")

    click_link "Register"

    expect(current_path).to eq('/register')

    name = 'Bob'
    address = '123 Who Cares Ln'
    city = 'Denver'
    state = 'CO'
    zip = '12345'
    email = 'me@me.com'
    password = 'secret'

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_button "Register"

    expect(current_path).to eq('/profile')

    expect(page).to have_content("Registration successful! You are now logged in.")
    expect(page).to have_content("Welcome, #{name}!")
  end

  it 'does not allow the visitor to register with incomplete information' do
    visit '/'

    expect(page).to have_link("Register")

    click_link "Register"

    expect(current_path).to eq('/register')

    name = 'Bob'
    address = '123 Who Cares Ln'
    city = 'Denver'
    state = 'CO'
    zip = '12345'
    email = 'me@me.com'
    password = 'secret'

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_button "Register"

    expect(current_path).to eq('/register')

    expect(page).to have_content("Zip can't be blank")
  end

  it 'does not allow the visitor to register unless the email address is unique' do
    User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'me@me.com', password: 'secret')

    visit '/register'

    name = 'Tom'
    address = '123 Who Cares Ln'
    city = 'Denver'
    state = 'CO'
    zip = '12345'
    email = 'me@me.com'
    password = 'secret'

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_button "Register"

    expect(current_path).to eq('/register')
    expect(page).to have_content('Email has already been taken')
    expect(page).to have_field('Name', with: name)
    expect(page).to have_field('Address', with: address)
    expect(page).to have_field('City', with: city)
    expect(page).to have_field('State', with: state)
    expect(page).to have_field('Zip', with: zip)
    expect(page).to_not have_field('Email', with: email)
  end
end
