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
    describe 'when displaying the list of foods' do
      before :each do
        visit new_user_session_path
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'p@55w0rd'
        click_button 'Log in'
        visit foods_path
      end
  
      it 'displays the list of foods' do
        expect(page).to have_content 'Foods'
      end
    end
  
    describe 'when not displaying the list of foods' do
      it "does not display the food's name" do
        visit foods_path
        expect(page).not_to have_text('Spaghetti')
      end
  
      it "does not display the food's measurement_unit" do
        visit foods_path
        expect(page).not_to have_text('grams')
      end
  
      it 'does not have a new food button' do
        visit foods_path
        expect(page).not_to have_link('Add Food')
      end
  
      it 'does not delete a food' do
        visit foods_path
        expect(page).not_to have_button('Delete')
      end
    end
  end
end
