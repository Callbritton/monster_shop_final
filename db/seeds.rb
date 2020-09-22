# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30 )
brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30)


regular_user = megan.users.create!(name: 'Reg', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'reg@email.com', password: '123', role: 0)
merchant_user = megan.users.create!(name: 'Merchant', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'merchant@email.com', password: 'merchant', role: 1)
admin_user = megan.users.create!(name: 'Admin', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'admin@email.com', password: 'admin', role: 1)

discount1 = megan.discounts.create!(name: "10% Off!", percent: 10, minimum_quantity: 3)
discount2 = megan.discounts.create!(name: "15% Off!", percent: 10, minimum_quantity: 6)
discount3 = megan.discounts.create!(name: "20% Off!", percent: 20, minimum_quantity: 8)
discount4 = megan.discounts.create!(name: "50% Off!", percent: 50, minimum_quantity: 5)
