require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @megan.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    @discount1 = @megan.discounts.create!(name: "10% Off!", percent: 10, minimum_quantity: 10)
    @discount2 = @megan.discounts.create!(name: "20% Off!", percent: 20, minimum_quantity: 20)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "When I visit my merchant dashboard I see a link to my discounts index" do
    visit "/merchant"
    click_on "Current Discounts"
    expect(current_path).to eq("/merchant/discounts")

    within "#discount-#{@discount1.id}" do
      expect(page).to have_content("10% off when you buy 10 items!")
    end
    within "#discount-#{@discount2.id}" do
      expect(page).to have_content("20% off when you buy 20 items!")
    end
  end
end
