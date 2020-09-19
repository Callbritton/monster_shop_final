require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @megan.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "I can create a new discount" do
    visit "/merchant"
    click_on "Current Discounts"
    expect(current_path).to eq("/merchant/discounts")

    click_on "Create New Discount"
    expect(current_path).to eq("/merchant/discounts/new")

    fill_in "Name", with: "30% Off"
    fill_in "Percent", with: 30
    fill_in "Minimum quantity", with: 30
    click_on "Create Discount"

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("Your discount has been created")
    expect(page).to have_content("30% Off")
  end

  it "I can not create a new discount if all fields are not complete" do
    visit "/merchant"
    click_on "Current Discounts"
    expect(current_path).to eq("/merchant/discounts")

    click_on "Create New Discount"
    expect(current_path).to eq("/merchant/discounts/new")

    fill_in "Name", with: "30% Off"
    fill_in "Percent", with: 30

    click_on "Create Discount"

    expect(current_path).to eq("/merchant/discounts/new")
    expect(page).to_not have_content("Your discount has been created")
    expect(page).to_not have_content("30% Off")
    expect(page).to have_content("Something has gone wrong, please try again")
  end
end
