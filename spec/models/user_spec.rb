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

  describe 'roles' do
    it "can be created as a default user" do
      default_user = User.create!(name: "Joe", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80202", email: "default@default.com", password: "default", role: 0)

      expect(default_user.role).to eq("user")
      expect(default_user.user?).to be_truthy
    end
    it "can be created as a merchant employee" do
      merchant_user = User.create!(name: "Sally", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80202", email: "merchant@merchant.com", password: "merchant", role: 1)

      expect(merchant_user.role).to eq("merchant")
      expect(merchant_user.merchant?).to be_truthy
    end
    it "can be created as an admin" do
      admin_user = User.create!(name: "Harry", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80202", email: "admin@admin.com", password: "admin", role: 2)

      expect(admin_user.role).to eq("admin")
      expect(admin_user.admin?).to be_truthy
    end
  end
end
