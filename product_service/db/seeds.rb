# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.delete_all
Category.delete_all

category_1 = Category.create(name: 'infantil');
category_2 = Category.create(name: 'adulto');

Product.create([
    { name: 'Camisa Azul',     value: 10.50, category: category_1 },
    { name: 'Camisa Vermelha', value: 11.90, category: category_1 },
    { name: 'Camisa Verde',    value: 9.30, category: category_1 },
    { name: 'Bermuda Verde',   value: 15.20, category: category_2 }
])