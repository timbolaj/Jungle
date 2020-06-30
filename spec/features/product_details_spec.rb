require 'rails_helper'

RSpec.feature "ProductDetails", type: :feature, js: true do
  # Click on a product partial
  # Test if I make it to that partial page
  before :each do
    @category = Category.create! name: 'Apparel'

    @category.products.create!(
      name: Faker::Hipster.sentence(3),
      description: Faker::Hipster.paragraph(4),
      image: open_asset('apparel1.jpg'),
      quantity: 10,
      price: 64.99
    )
  end

  scenario "Clicking on a product will lead to the show template" do
    # ACT
    visit root_path
    # puts page.html
    page.find('.product').find('header').click_link

    # DEBUG / VERIFY

    expect(page).to have_css '.products-show'
  end
end
