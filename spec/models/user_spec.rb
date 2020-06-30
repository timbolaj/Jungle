require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do

      it "is valid with valid attributes of first/last name, password/password_confirmation and email" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'testing')

        expect(@user).to be_valid
      end

      it "is invalid with first name as nil" do
        @user = User.create(first_name: nil, last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'test1')
        expect(@user.errors.full_messages.length).to eql(1)

        expect(@user.errors.full_messages[0]).to eql("First name can't be blank")
        expect(@user).to_not be_valid
      end

      it "is invalid with last name as nil" do
        @user = User.create(first_name: 'test', last_name: nil, password: 'test1', password_confirmation: 'test1', email: 'test2')

        expect(@user.errors.full_messages.length).to eql(1)
        expect(@user.errors.full_messages[0]).to eql("Last name can't be blank")
        expect(@user).to_not be_valid
      end

      it "is invalid with no password" do
        @user = User.create(first_name: 'test', last_name: 'test1', password: nil, password_confirmation: 'test1', email: 'test3')
        expect(@user.errors.full_messages.length).to eql(3)
        expect(@user.errors.full_messages[0]).to eql("Password can't be blank")
        expect(@user.errors.full_messages[1]).to eql("Password can't be blank")
        expect(@user.errors.full_messages[2]).to eql("Password is too short (minimum is 5 characters)")
        expect(@user).to_not be_valid
      end

      it "is invalid with no password confirmation" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: nil, email: 'test4')

        expect(@user.errors.full_messages.length).to eql(1)
        expect(@user.errors.full_messages[0]).to eql("Password confirmation can't be blank")
        expect(@user).to_not be_valid
      end
      
      it "is invalid with no email" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: nil)

        expect(@user.errors.full_messages.length).to eql(1)
        expect(@user.errors.full_messages[0]).to eql("Email can't be blank")
        expect(@user).to_not be_valid
      end

    context "verifying email inputs" do
      it "is invalid if email is already taken: case sensitive" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'test3')
        @user2 = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'test3')

        expect(@user2.errors.full_messages.length).to eql(1)
        expect(@user2.errors.full_messages[0]).to eql("Email has already been taken")
        expect(@user2).to_not be_valid

        expect(@user.errors.full_messages.length).to eql(0)
        expect(@user).to be_valid
      end

      it "is invalid if email is already taken: not case sensitive" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'test4')
        @user2 = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'TeSt4')
      
        expect(@user2.errors.full_messages.length).to eql(1)
        expect(@user2.errors.full_messages[0]).to eql("Email has already been taken")
        expect(@user2).to_not be_valid

        expect(@user.errors.full_messages.length).to eql(0)
        expect(@user).to be_valid
      end
    end

    context "verifying password inputs" do
      it "is invalid if password and password confirmation do not match" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'tEsT', email: 'test2')

        expect(@user.errors.full_messages.length).to eql(1)
        expect(@user.errors.full_messages[0]).to eql("Password confirmation doesn't match Password")
        expect(@user).to_not be_valid
      end

      it "is invalid if password has under 5 characters" do
        @user = User.create(first_name: 'test', last_name: 'test', password: 'test', password_confirmation: 'test', email: 'test3')
        expect(@user.errors.full_messages.length).to eql(1)
        expect(@user.errors.full_messages[0]).to eql("Password is too short (minimum is 5 characters)")
        expect(@user).to_not be_valid
      end
    end
  end

  describe '.authenticate_with_credentials' do
    it "is valid if email is in db and password matches email" do
      @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'testing')
      @authenticate = User.authenticate_with_credentials('testing', 'test1')

      expect(@authenticate).to eql(@user)
    end

    it "is valid if email is correct, in different case, with whitespace and password matches" do
      @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'testing')
      @authenticate = User.authenticate_with_credentials(' TeStInG   ', 'test1')

      expect(@authenticate).to eql(@user)

    end

    it "is invalid if user does not input an email" do
      @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'testing')
      @authenticate = User.authenticate_with_credentials(nil, 'test1')

      expect(@authenticate).to eql(nil)
    end

    it "is invalid if user does not input a password" do
      @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'testing')
      @authenticate = User.authenticate_with_credentials('test', nil)

      expect(@authenticate).to eql(nil)
    end

    it "is invalid if user inputs nothing" do
      @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'testing')
      @authenticate = User.authenticate_with_credentials(nil, nil)

      expect(@authenticate).to eql(nil)
    end

    it "is invalid if user inputs right email, but the wrong password (case-sensitive)" do
      @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'testing')
      @authenticate = User.authenticate_with_credentials('testing', 'Test1')

      expect(@authenticate).to eql(nil)
    end

    it "is valid if user registers with spaces in email (case-insensitive) with and logs in with right email and right password" do
      @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: '  Testing ')
      @authenticate = User.authenticate_with_credentials('  testing', 'test1')

      expect(@authenticate).to eql(@user)
    end

  end
end