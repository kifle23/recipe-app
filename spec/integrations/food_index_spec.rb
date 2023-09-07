require 'rails_helper'

describe 'Food', type: :system do
  before do
    User.destroy_all
    @user = User.new(name: 'Ruby Guy', email: 'test@email.com', password: 'p@55w0rd', password_confirmation: 'p@55w0rd')
    @user.skip_confirmation!
    @user.save

    Food.destroy_all
    @food = Food.new(name: 'Spaghetti', measurement_unit: 'grams', price: 1.2, user: @user)
    @food.save
  end

  describe 'show list of foods' do
    before :each do
      visit new_user_session_path
      fill_in 'Email', with: 'test@email.com'
      fill_in 'Password', with: 'p@55w0rd'
      click_button 'Log in'
    end

    it 'should display the list of foods' do
      expect(page).to have_content 'Foods'
    end

    it "should display the food's name" do
      visit foods_path
      expect(page).to have_text('Spaghetti')
    end

    it "should display the food's measurement_unit" do
      visit foods_path
      expect(page).to have_text('grams')
    end

    it 'should have a new food button' do
      visit foods_path
      expect(page).to have_link('Add Food')
    end

    it 'should delete a food' do
      visit foods_path
      click_button 'Delete'
      expect(page).to have_content 'Food was successfully deleted.'
    end
  end
end
