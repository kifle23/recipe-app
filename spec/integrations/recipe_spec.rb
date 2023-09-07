require 'rails_helper'

RSpec.describe 'Recipes', type: :system do
  include Devise::Test::IntegrationHelpers

  before(:each) do
    @user = User.create(
      name: 'User one',
      email: 'user@example.com',
      password: 'password',
      confirmation_token: '23moe234f',
      confirmed_at: Time.now, confirmation_sent_at: Time.now
    )
    @recipe = Recipe.create(
      name: 'recipe',
      preparation_time: 10,
      cooking_time: 20,
      description: 'my recipe',
      public: false,
      user_id: @user.id
    )

    sign_in @user
  end

  describe '#index' do
    before(:each) do
      visit recipes_path
    end

    it 'should see a recipe name' do
      assert_text @recipe.name
    end

    it 'should see the recipe description' do
      assert_text @recipe.description
    end

    it 'on clicking on a recipe, should redirect to that recipe show page' do
      click_on @recipe.name
      assert_current_path recipe_path(@recipe)
    end
  end

  describe '#show' do
    before(:each) do
      visit recipe_path(@recipe)
    end

    scenario 'should see a recipe name' do
      assert_text @recipe.name
    end

    scenario 'should see the recipe description' do
      assert_text @recipe.description
    end

    scenario 'on click on Add Ingedrient, should redirect to the ingredient page' do
      click_on 'Add Ingedrient'
      assert_current_path new_recipe_recipe_food_path(@recipe)
    end
  end
end
