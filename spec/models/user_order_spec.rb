require 'rails_helper'

RSpec.describe UserOrder do
  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :order }
  end
end
