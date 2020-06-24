class Admin::DashboardController < ApplicationController

  http_basic_authenticate_with name: ENV["USERNAME"], password: ENV["PASSWORD"]

  def show
    @product_count = Product.all.count
    @apparel_count = Product.where(category_id: 1).count
    @electronic_count = Product.where(category_id: 2).count
    @furniture_count = Product.where(category_id: 3).count
  end
end
