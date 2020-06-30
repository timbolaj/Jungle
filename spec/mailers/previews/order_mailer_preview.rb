# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  def send_email
    product = Product.new(name: 'product', description: "some kind of product", price_cents: 1000, quantity: 100, category_id: 1, image: "https://miro.medium.com/max/5760/1*2bjwCLaA8TfH40OXcyLNvA.png")
    quantity = 12
    order = Order.create(total_cents: 1000, stripe_charge_id: 2, email: 'bob@bob')
    order.line_items.new(
      product: product,
      quantity: quantity,
      item_price: product.price,
      total_price: product.price * quantity
    )
    # puts order.email
    OrderMailer.send_email(order)
  end
end
