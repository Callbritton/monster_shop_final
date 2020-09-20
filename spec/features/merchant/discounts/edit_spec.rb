require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @megan.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    @discount1 = @megan.discounts.create!(name: "10% Off!", percent: 10, minimum_quantity: 10)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "can access an edit form from the discounts index page" do
    visit "/merchant/discounts"

    within "#discount-#{@discount1.id}" do
      click_on "Edit Discount"
    end

    expect(page).to have_field('Name', with: '10% Off!')
    expect(page).to have_field('Percent', with: 10)
    expect(page).to have_field('Minimum quantity', with: 10)
  end

  it "can edit a discount" do
    visit "/merchant/discounts/#{@discount1.id}/edit"

    fill_in "Name", with: "30% Off"
    fill_in "Percent", with: 30
    fill_in "Minimum quantity", with: 30
    click_on "Edit Discount"

    expect(page).to have_content("Your discount has been updated!")
    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("30% Off")
  end

  it "must complete all fields to edit a discount" do
    visit "/merchant/discounts/#{@discount1.id}/edit"

    fill_in "Name", with: ""
    fill_in "Percent", with: 30
    fill_in "Minimum quantity", with: 30
    click_on "Edit Discount"

    expect(page).to have_content("All fields must be completed. Please try again.")
    expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")
  end
end
