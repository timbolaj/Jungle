class Product < ActiveRecord::Base

  monetize :price_cents, numericality: true
  mount_uploader :image, ProductImageUploader

  belongs_to :category

  before_validation :ensure_has_price

  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :category, presence: true

  private
    def ensure_has_price
      if self.price <= 0
        self.price = false 
      end
      self.price
    end

end
