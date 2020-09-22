require 'rails_helper'

RSpec.describe "As a user" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @jim = Merchant.create!(name: 'Jims Tigers', address: '2020 E 3rd St', city: 'The Springs', state: 'CO', zip: 80111)
    @merchant_user = @megan.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
    @default_user = User.create!(name: "Chuck Walters", address: "3345 S Main St", city: "Denver", state: "CO", zip: 89978, email: "default@email", password: "default")

    @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 25 )
    @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 23 )
    @hobbit = @megan.items.create!(name: 'Hobbit', description: "I'm a Hobbit!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 28 )

    @hippo = @jim.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 23 )
    @tiger = @jim.items.create!(name: 'Tiger', description: "I'm a Tiger!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 33 )
    @chicken = @jim.items.create!(name: 'Chicken', description: "I'm a Chicken!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 44 )

    @discount1 = @megan.discounts.create!(name: "10% Off!", percent: 10, minimum_quantity: 5)
    @discount2 = @megan.discounts.create!(name: "15% Off!", percent: 10, minimum_quantity: 4)
    @discount3 = @megan.discounts.create!(name: "20% Off!", percent: 20, minimum_quantity: 2)
    @discount4 = @megan.discounts.create!(name: "50% Off!", percent: 50, minimum_quantity: 3)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)
  end

  it "can apply a discount when a user purchases the minimum quantity of items. This discount can be seen at '/cart'" do

    visit "/items/#{@ogre.id}"
    click_on "Add to Cart"

    visit "/cart"

    within "#item-#{@ogre.id}" do
      click_on "More of This!"
      click_on "More of This!"
    end

    expect(page).to have_content("Price: $20.00")
    expect(page).to have_content("Quantity: 3")
    expect(page).to have_content("#{@discount4.name} discount applied!")
    expect(page).to have_content("Subtotal: $30.00")
  end

  it "applies the greater of two qualifying discounts when there is a conflict" do
    visit "/items/#{@ogre.id}"
    click_on "Add to Cart"
    visit "/items/#{@giant.id}"
    click_on "Add to Cart"

    visit "/cart"

    within "#item-#{@ogre.id}" do
      click_on "More of This!"
    end

    within "#item-#{@giant.id}" do
      click_on "More of This!"
      click_on "More of This!"
      click_on "More of This!"
    end

    expect(page).to have_content("Price: $20.00")
    expect(page).to have_content("Quantity: 2")
    expect(page).to have_content("#{@discount3.name} discount applied!")
    expect(page).to have_content("Subtotal: $32.00")

    expect(page).to have_content("Price: $50.00")
    expect(page).to have_content("Quantity: 4")
    expect(page).to have_content("Subtotal: $100.00")
    expect(page).to have_content("#{@discount4.name} discount applied!")
    expect(page).to_not have_content("#{@discount2.name} discount applied!")
  end

  it "Multiple items must be the same type to qualify for discounts"do

    visit "/items/#{@ogre.id}"
    click_on "Add to Cart"

    visit "/items/#{@giant.id}"
    click_on "Add to Cart"

    visit "/cart"

    expect(page).to_not have_content("#{@discount1.name} discount applied!")
    expect(page).to_not have_content("#{@discount2.name} discount applied!")
    expect(page).to_not have_content("#{@discount3.name} discount applied!")
    expect(page).to_not have_content("#{@discount4.name} discount applied!")

    within "#item-#{@ogre.id}" do
      click_on "More of This!"
    end

    expect(page).to have_content("#{@discount3.name} discount applied!")
  end
end
