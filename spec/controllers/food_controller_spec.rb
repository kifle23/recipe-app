require 'rails_helper'

RSpec.describe FoodsController, type: :controller do
  let(:user) { double('User') }
  let(:food) { double('Food') }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
    allow(Food).to receive(:find).and_return(food)
  end

  describe 'GET #index' do
    it 'assigns the user foods to @foods' do
      allow(user).to receive(:foods).and_return([food])
      get :index
      expect(assigns(:foods)).to eq([food])
    end
  end

  describe 'GET #new' do
    it 'assigns a new food to @food' do
      get :new
      expect(assigns(:food)).to be_a_new(Food)
    end
  end

  describe 'POST #create' do
    let(:food_params) { { name: 'Pizza', measurement_unit: 'Slice', price: 10.99, quantity: 1, user_id: 1 } }

    before do
      allow(Food).to receive(:new).and_return(food)
      allow(food).to receive(:user=)
      allow(food).to receive(:save).and_return(save_result)
    end

    context 'when the food is successfully created' do
      let(:save_result) { true }

      it 'assigns the current user to the food' do
        expect(food).to receive(:user=).with(user)
        post :create, params: { food: food_params }
      end

      it 'redirects to the created food' do
        post :create, params: { food: food_params }
        expect(response).to redirect_to(food_url(food))
      end

      it 'sets a flash notice' do
        post :create, params: { food: food_params }
        expect(flash[:notice]).to eq('Food was successfully created.')
      end
    end

    context 'when the food fails to save' do
      let(:save_result) { false }

      it 'renders the new template' do
        post :create, params: { food: food_params }
        expect(response).to render_template(:new)
      end

      it 'assigns the unsaved food to @food' do
        post :create, params: { food: food_params }
        expect(assigns(:food)).to eq(food)
      end

    end
  end

  describe 'DELETE #destroy' do
    before do
      allow(food).to receive(:destroy)
    end

    it 'destroys the requested food' do
      expect(food).to receive(:destroy)
      delete :destroy, params: { id: 1 }
    end

    it 'redirects to the foods index' do
      delete :destroy, params: { id: 1 }
      expect(response).to redirect_to(foods_url)
    end

    it 'sets a flash notice' do
      delete :destroy, params: { id: 1 }
      expect(flash[:notice]).to eq('Food was successfully deleted.')
    end
  end
end