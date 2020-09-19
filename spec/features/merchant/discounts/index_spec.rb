require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @megan.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    discount = @megan.discounts.create!(name: "10 Off!", percent: 10, minimum_quantity: 10)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "When I visit my merchant dashboard I see a link to my discounts index" do
    visit "/merchant"
    click_on "Current Discounts"

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("10 Off!")
  end
end
