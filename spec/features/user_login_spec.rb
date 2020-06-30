require 'rails_helper'

RSpec.feature "UserLogins", type: :feature, js: true do
  
  before :each do
    @user = User.create(first_name: 'test', last_name: 'test', password: 'test1', password_confirmation: 'test1', email: 'testing')
  end

  scenario "Filling out the login page will rerender the home page with the email in the navbar" do
    visit root_path
    page.find('nav').click_on("Login")

    expect(page).to have_css '.form-control'

    fill_in 'sessions_email', with: 'testing'
    fill_in 'sessions_password', with: 'test1'

    page.click_on("Submit")

    expect(page).to have_css('.products-index')
    expect(page).to have_text "testing"

    save_screenshot 
  end
end
