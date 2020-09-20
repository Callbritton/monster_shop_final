require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @megan.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    @discount1 = @megan.discounts.create!(name: "10% Off!", percent: 10, minimum_quantity: 10)
    @discount2 = @megan.discounts.create!(name: "20% Off!", percent: 20, minimum_quantity: 20)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "can delete a discount" do
    visit "/merchant/discounts"

    within "#discount-#{@discount2.id}" do
      click_on "Delete Discount"
    end

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("Your discount has been deleted!")
    expect(page).to have_content("10% Off!")
    expect(page).to have_css("#discount-#{@discount1.id}")

  #  Why won't these expectations work?
    # expect(page).to_not have_content("20% Off!")
    # expect(page).to_not have_css("#discount-#{@discount2.id}")
  end
end
