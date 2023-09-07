require 'rails_helper'

describe 'Foods new', type: :system do
  before do
    User.destroy_all
    @user = User.new(name: 'Ruby Guy', email: 'test@email.com', password: 'p@55w0rd', password_confirmation: 'p@55w0rd')
    @user.skip_confirmation!
    @user.save
  end

  describe 'Add new food' do
    before :each do
      visit new_food_path
      fill_in 'Email', with: 'test@email.com'
      fill_in 'Password', with: 'p@55w0rd'
      click_button 'Log in'
    end

    it 'should have name input field' do
      expect(page).to have_field('food_name')
    end

    it 'should have measurement unit  input field' do
      expect(page).to have_field('food_measurement_unit')
    end
    it 'should have price input field' do
      expect(page).to have_field('food_price')
    end

    it 'should have a add button' do
      expect(page).to have_button('Submit')
    end
  end
end
