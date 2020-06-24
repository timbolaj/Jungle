class Admin::DashboardController < ApplicationController

  http_basic_authenticate_with name: ENV["USERNAME"], password: ENV["PASSWORD"]

  def show
    @category_name_to_id = {}
    @product_per_category_count = {}
    @product = Product.all
    @product_category = Category.joins(:products)

    @product_category.map do |n|
      unless @product_per_category_count[n.name] == nil
        @product_per_category_count[n.name] += 1
      else
        @product_per_category_count[n.name] = 1
        @category_name_to_id[n.name] = n.id
      end
    end
  end
end
