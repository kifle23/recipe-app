require 'rails_helper'

RSpec.describe PublicRecipesController, type: :request do
  let(:user) { User.new(name: 'User1', email: 'user1@gmail.com', password: '123123') }
  let(:recipe) do
    Recipe.new(name: 'recipe_1',
               preparation_time: 20,
               cooking_time: 30,
               description: 'interesting recipe',
               public: false,
               user_id: user.id)
  end

  before do
    user.skip_confirmation!
    user.save
    recipe.save
    authenticate_user(user)
  end

  def authenticate_user(user)
    post user_session_path, params: { user: { email: user.email, password: user.password, name: user.name } }
    follow_redirect!
  end

  describe 'Get #index' do
    it 'returns a successful response' do
      get public_recipes_path
      expect(response).to have_http_status(:ok)
    end
  end
end
