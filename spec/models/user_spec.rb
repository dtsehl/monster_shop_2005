require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :role }
  end

  describe 'relationships' do
    it { should have_many :user_orders }
    it { should have_many(:orders).through(:user_orders) }
  end

  describe "roles" do
    it "can be created as an user" do
      user = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'me@me.com', password: 'secret')

      expect(user.role).to eq("user")
      expect(user.user?).to be_truthy
    end

    it "can be created as a merchant user" do
      user = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'me@me.com', password: 'secret', role: 1)


      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
    end

    it "can be created as a admin user" do
      user = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'me@me.com', password: 'secret', role: 2)


      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end
  end
end
