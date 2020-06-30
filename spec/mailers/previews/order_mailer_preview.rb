# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  def send_email
    order = Order.create(total_cents: 1000, stripe_charge_id: 2, email: 'bob@bob')
    # puts order.email
    OrderMailer.send_email(order)
  end
end
