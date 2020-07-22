require 'rails_helper'

RSpec.describe 'User can login' do
  it 'allows a regular user to log in with valid information' do
    user = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret')

    visit '/login'
    expect(page).to have_field("Email Address")
    expect(page).to have_field("Password")

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Log In"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Hello, #{user.name}, you are now logged in.")
  end
  it 'allows a merchant user to log in with valid information' do
    m_user = User.create!(name: 'Merchant', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'merchant@me.com', password: 'secret', role: 1)

    visit '/login'
    expect(page).to have_field("Email Address")
    expect(page).to have_field("Password")

    fill_in :email, with: m_user.email
    fill_in :password, with: m_user.password

    click_button "Log In"

    expect(current_path).to eq('/merchant/dashboard')
    expect(page).to have_content("Hello, #{m_user.name}, you are now logged in.")
  end
  it 'allows an admin user to log in with valid information' do
    a_user = User.create!(name: 'Admin', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'admin@me.com', password: 'secret', role: 2)

    visit '/login'
    expect(page).to have_field("Email Address")
    expect(page).to have_field("Password")

    fill_in :email, with: a_user.email
    fill_in :password, with: a_user.password

    click_button "Log In"

    expect(current_path).to eq('/admin/dashboard')
    expect(page).to have_content("Hello, #{a_user.name}, you are now logged in.")
  end

  it 'does not allow user to log in with bad credentials' do
    a_user = User.create!(name: 'Admin', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'admin@me.com', password: 'secret', role: 2)

    visit '/login'

    fill_in :email, with: "BAD@me.com"
    fill_in :password, with: a_user.password

    click_button "Log In"

    expect(current_path).to eq('/login')

    expect(page).to have_content("Log in information incorrect, please try again.")

    fill_in :email, with: a_user.email
    fill_in :password, with: "nopety"

    click_button "Log In"

    expect(current_path).to eq('/login')

    expect(page).to have_content("Log in information incorrect, please try again.")
  end
end


# User Story 14, User cannot log in with bad credentials
#
# As a visitor
# When I visit the login page ("/login")
# And I submit invalid information
# Then I am redirected to the login page
# And I see a flash message that tells me that my credentials were incorrect
# I am NOT told whether it was my email or password that was incorrect
