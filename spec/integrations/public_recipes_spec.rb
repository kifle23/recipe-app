require 'rails_helper'

RSpec.describe PublicRecipesController, type: :system do
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
      name: 'my_recipe',
      preparation_time: 20,
      cooking_time: 30,
      description: 'It\'s a very delicious meal.',
      public: true,
      user_id: @user.id
    )
    sign_in @user
  end

  describe '#index' do
    before(:each) do
      visit public_recipes_path
    end

    scenario 'should have title Public Recipe' do
      assert_text 'Public Recipes'
    end

    scenario 'should not have New recipe button' do
      assert_no_text 'New recipe'
    end

    scenario 'should contain recipe name' do
      assert_text @recipe.name
    end

    scenario 'should have recipe description' do
      assert_text @recipe.description
    end

    scenario 'should have recipe owner name' do
      assert_text "by: #{@user.name}"
    end
  end

  describe '#show' do
    before(:each) do
      visit public_recipes_path
    end

    scenario 'should go to recipe show page when clicked on' do
      click_on @recipe.name
      assert_text @recipe.name
    end

    scenario 'should have preparation time' do
      click_on @recipe.name
      assert_text @recipe.preparation_time
    end

    scenario 'should have cooking time' do
      click_on @recipe.name
      assert_text @recipe.cooking_time
    end

    scenario 'should have steps' do
      click_on @recipe.name
      assert_text @recipe.description
    end

    scenario 'should have generate shopping list button' do
      click_on @recipe.name
      assert_text 'Generate Shopping List'
    end
  end
end
