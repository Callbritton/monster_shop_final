require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @megan.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    @discount1 = @megan.discounts.create!(name: "10% Off!", percent: 10, minimum_quantity: 10)
    @discount2 = @megan.discounts.create!(name: "20% Off!", percent: 20, minimum_quantity: 20)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "I can create a new discount" do
    visit "/merchant"
    click_on "Current Discounts"
    expect(current_path).to eq("/merchant/discounts")

    click_on "Create New Discount"
    expect(current_path).to eq("/merchant/discounts/new")

    fill_in "Name", with: "10% Off"
    fill_in "Percent", with: 10
    fill_in "Minimum quantity", with: 10
    click_on "Create Discount"
  end
end
