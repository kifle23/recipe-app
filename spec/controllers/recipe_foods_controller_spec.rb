require 'rails_helper'

RSpec.describe RecipeFoodsController, type: :request do
  let(:user) { User.new(name: 'test', email: 'test@test.com', password: 'password') }
  let(:recipe) do
    Recipe.new(name: 'recipe', preparation_time: 10, cooking_time: 20, description: 'my recipe', public: false,
               user_id: user.id)
  end

  before do
    user.skip_confirmation!
    user.save
    recipe.save
  end

  def authenticate_user(user)
    post user_session_path, params: { user: { email: user.email, password: user.password, name: user.name } }
    follow_redirect!
  end

  describe 'GET #new' do
    it 'returns a success response' do
      authenticate_user(user)
      get new_recipe_recipe_food_path(recipe)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:food) { Food.create(name: 'food', measurement_unit: 'units', price: 10, quantity: 10, user_id: user.id) }

    it 'should create a new RecipeFood' do
      authenticate_user(user)
      expect do
        post recipe_recipe_foods_path(recipe), params: { recipe_food: { recipe_id: recipe.id, food_id: food.id } }
      end.to change(RecipeFood, :count).by(1)
    end

    it 'should redirect to the created recipe' do
      authenticate_user(user)
      post recipe_recipe_foods_path(recipe), params: { recipe_food: { recipe_id: recipe.id, food_id: food.id } }
      expect(response).to redirect_to(recipe_path(recipe))
    end
  end

  describe 'GET #edit' do
    let(:food) { Food.create(name: 'food', measurement_unit: 'units', price: 10, quantity: 10, user_id: user.id) }
    let!(:recipe_food) { RecipeFood.create(recipe_id: recipe.id, food_id: food.id) }

    it 'returns a success response' do
      authenticate_user(user)
      get edit_recipe_recipe_food_path(recipe, recipe_food)
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    let(:food) { Food.create(name: 'food', measurement_unit: 'units', price: 10, quantity: 10, user_id: user.id) }
    let!(:recipe_food) { RecipeFood.create(recipe_id: recipe.id, food_id: food.id) }

    it 'should update the recipe_food' do
      authenticate_user(user)
      patch recipe_recipe_food_path(recipe, recipe_food),
            params: { recipe_food: { recipe_id: recipe.id, food_id: food.id, quantity: 20 } }
      expect(recipe_food.reload.quantity).to eq(20)
    end

    it 'should redirect to the recipe' do
      authenticate_user(user)
      patch recipe_recipe_food_path(recipe, recipe_food),
            params: { recipe_food: { recipe_id: recipe.id, food_id: food.id, quantity: 20 } }
      expect(response).to redirect_to(recipe_path(recipe))
    end
  end

  describe 'DELETE #destroy' do
    let(:food) { Food.create(name: 'food', measurement_unit: 'units', price: 10, quantity: 10, user_id: user.id) }
    let!(:recipe_food) { RecipeFood.create(recipe_id: recipe.id, food_id: food.id) }

    it 'should delete the recipe_food' do
      authenticate_user(user)
      expect do
        delete recipe_recipe_food_path(recipe, recipe_food)
      end.to change(RecipeFood, :count).by(-1)
    end

    it 'should redirect to the recipe' do
      authenticate_user(user)
      delete recipe_recipe_food_path(recipe, recipe_food)
      expect(response).to redirect_to(recipe_path(recipe))
    end
  end
end
