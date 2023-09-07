require 'rails_helper'

RSpec.describe 'ShoppingLists', type: :feature, js: true do
  before do
    User.destroy_all
    @user = User.new(name: 'Ruby Guy', email: 'test@email.com', password: 'p@55w0rd', password_confirmation: 'p@55w0rd')
    @user.skip_confirmation!
    @user.save

    Food.destroy_all
    @food = Food.new(name: 'Spaghetti', measurement_unit: 'grams', price: 1.2, user: @user)
    @food.save

    Recipe.destroy_all
    @recipe = Recipe.create!(name: 'Gallo Pinto', preparation_time: 4.5, cooking_time: 8,
                             description: 'Traditional costarrican dish', public: true, user: @user)
    @recipe.save
    
    RecipeFood.destroy_all
    @recipe_food = RecipeFood.create!(quantity: 2.1, recipe: @recipe, food: @food)
    @recipe_food.save
  end

  describe 'show shopping list' do
    before :each do
      visit new_user_session_path
      fill_in 'Email', with: 'test@email.com'
      fill_in 'Password', with: 'p@55w0rd'
      click_button 'Log in'
    end
    
    it 'Display shopping list page' do
        visit shopping_lists_path
        expect(page).to have_content(/Shopping list/i)
    end
  end
end