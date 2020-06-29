class User < ActiveRecord::Base
  has_secure_password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true
  validates_length_of :password, :minimum => 5
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_confirmation, presence: true

  def self.authenticate_with_credentials(email, password)
    return nil if email == nil

    @user = User.find_by_email(email.downcase.strip)
    @user && @user.authenticate(password) ? @user : nil
  end
end
