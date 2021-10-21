# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


30.times do
    Coffe.create(name: Faker::Name.name,
    price: rand(1990..5490),
    origin: Faker::Coffee.origin,
    blend: Faker::Coffee.blend_name
    )
end

200.times do
    Sale.create(amount: rand(2000..10000),
    coffe_id: rand(Coffe.first.id..Coffe.last.id),
    created_at: Faker::Date.between(from: 1.year.ago, to: Date.today)
    )
end