require 'rails_helper'

RSpec.describe "As an Admin" do
  it "I can see all registered users in a path only accessible by admins" do
    admin_1 = User.create!(name: 'Admin_1', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'admin_1@me.com', password: 'secret', role: 2)
    admin_2 = User.create!(name: 'Admin_2', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'admin_2@me.com', password: 'secret', role: 2)
    merchant_1 = User.create!(name: 'Merchant1', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'merchant_1@me.com', password: 'secret', role: 1)
    merchant_2 = User.create!(name: 'Merchant2', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'merchant_2@me.com', password: 'secret', role: 1)
    user_1 = User.create!(name: 'User1', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'user_1@me.com', password: 'alsosecret', role: 0)
    user_2 = User.create!(name: 'User2', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'user_2@me.com', password: 'alsosecret', role: 0)

    visit '/login'
    fill_in :email, with: admin_1.email
    fill_in :password, with: admin_1.password
    click_button "Log In"

    within '.topnav' do
      click_on "All Users"
    end

    expect(current_path).to eq("/admin/users")

    expect(page).to have_link(admin_1.name)
    expect(page).to have_link(admin_2.name)
    expect(page).to have_link(merchant_1.name)
    expect(page).to have_link(merchant_2.name)
    expect(page).to have_link(user_1.name)
    expect(page).to have_link(user_2.name)

    within "#user-#{user_1.id}" do
      expect(page).to have_content(user_1.created_at)
      expect(page).to have_content("User")
    end

    within "#user-#{merchant_1.id}" do
      expect(page).to have_content(merchant_1.created_at)
      expect(page).to have_content("Merchant")
    end

    within "#user-#{admin_1.id}" do
      expect(page).to have_content(admin_1.created_at)
      expect(page).to have_content("Admin")
    end

    click_on user_1.name

    expect(current_path).to eq("/admin/users/#{user_1.id}")
  end

  it "I can see the user's show page which is the same as their own except I cannot edit their profile" do
    admin_1 = User.create!(name: 'Admin_1', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'admin_1@me.com', password: 'secret', role: 2)
    user_1 = User.create!(name: 'User1', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'user_1@me.com', password: 'alsosecret', role: 0)

    visit '/login'
    fill_in :email, with: admin_1.email
    fill_in :password, with: admin_1.password
    click_button "Log In"

    within '.topnav' do
      click_on "All Users"
    end

    click_on user_1.name

    expect(page).to have_content(user_1.name)
    expect(page).to have_content(user_1.address)
    expect(page).to have_content(user_1.city)
    expect(page).to have_content(user_1.state)
    expect(page).to have_content(user_1.zip)
    expect(page).to have_content(user_1.email)
    expect(page).to have_link('Edit Password')
    expect(page).to have_link('My Orders')
  end
end
