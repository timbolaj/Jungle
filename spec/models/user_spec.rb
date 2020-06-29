require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do

      it "is valid with valid attributes of first/last name, password/password_confirmation and email" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test', password_confirmation: 'test', email: 'testing')

        expect(@user).to be_valid
      end

      it "is invalid with first name as nil" do
        @user = User.create(first_name: nil, last_name: 'test', password: 'test', password_confirmation: 'test', email: 'test1')
        expect(@user.errors.full_messages.length).to eql(1)

        expect(@user.errors.full_messages[0]).to eql("First name can't be blank")
        expect(@user).to_not be_valid
      end

      it "is invalid with last name as nil" do
        @user = User.create(first_name: 'test', last_name: nil, password: 'test', password_confirmation: 'test', email: 'test2')

        expect(@user.errors.full_messages.length).to eql(1)
        expect(@user.errors.full_messages[0]).to eql("Last name can't be blank")
        expect(@user).to_not be_valid
      end

      it "is invalid with no password" do
        @user = User.create(first_name: 'test', last_name: 'test', password: nil, password_confirmation: 'test', email: 'test3')
        expect(@user.errors.full_messages.length).to eql(2)
        expect(@user.errors.full_messages[0]).to eql("Password can't be blank")
        expect(@user.errors.full_messages[1]).to eql("Password can't be blank")
        expect(@user).to_not be_valid
      end

      it "is invalid with no password confirmation" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test', password_confirmation: nil, email: 'test4')

        expect(@user.errors.full_messages.length).to eql(1)
        expect(@user.errors.full_messages[0]).to eql("Password confirmation can't be blank")
        expect(@user).to_not be_valid
      end
      
      it "is invalid with no email" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test', password_confirmation: 'test', email: nil)

        expect(@user.errors.full_messages.length).to eql(1)
        expect(@user.errors.full_messages[0]).to eql("Email can't be blank")
        expect(@user).to_not be_valid
      end

    context "verifying email inputs" do
      it "is invalid if email is already taken: case sensitive" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test', password_confirmation: 'test', email: 'test3')
        @user2 = User.create(first_name: 'test', last_name: 'test', password: 'test', password_confirmation: 'test', email: 'test3')

        expect(@user2.errors.full_messages.length).to eql(1)
        expect(@user2.errors.full_messages[0]).to eql("Email has already been taken")
        expect(@user2).to_not be_valid

        expect(@user.errors.full_messages.length).to eql(0)
        expect(@user).to be_valid
      end

      it "is invalid if email is already taken: not case sensitive" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test', password_confirmation: 'test', email: 'test4')
        @user2 = User.create(first_name: 'test', last_name: 'test', password: 'test', password_confirmation: 'test', email: 'TeSt4')
      
        expect(@user2.errors.full_messages.length).to eql(1)
        expect(@user2.errors.full_messages[0]).to eql("Email has already been taken")
        expect(@user2).to_not be_valid

        expect(@user.errors.full_messages.length).to eql(0)
        expect(@user).to be_valid
      end
    end

    it "is invalid if password and password confirmation do not match" do
      @user = User.create(first_name: 'test', last_name: 'test', password: 'test', password_confirmation: 'tEsT', email: 'test2')

      expect(@user.errors.full_messages.length).to eql(1)
      expect(@user.errors.full_messages[0]).to eql("Password confirmation doesn't match Password")
      expect(@user).to_not be_valid
    end
  end
end

