require 'rails_helper'

describe ShoppingListsController, type: :controller do
  let(:user) { double('User') }
  let(:recipe_foods) { double('RecipeFoods') }
  let(:general_foods) { double('GeneralFoods') }
  let(:missing_foods) { double('MissingFoods') }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
    allow(user).to receive(:recipes).and_return(recipe_foods)
    allow(recipe_foods).to receive(:joins).with(:foods).and_return(recipe_foods)
    allow(recipe_foods).to receive(:select).with('foods.*').and_return(recipe_foods)
    allow(user).to receive(:foods).and_return(general_foods)
    allow(recipe_foods).to receive(:-).with(general_foods).and_return(missing_foods)
    allow(missing_foods).to receive(:count).and_return(2)
    allow(controller).to receive(:calculate_total_price).and_call_original
    allow(controller).to receive(:calculate_total_price).with(missing_foods).and_return(25.99)
    allow(missing_foods).to receive(:map).and_return([
                                                       { name: 'Food 1', quantity: 2, measurement_unit: 'kg',
                                                         price: 12.99 }, { name: 'Food 2', quantity: 1,
                                                                           measurement_unit: 'piece', price: 13.00 }
                                                     ])
  end

  describe 'GET #index' do
    it 'assigns the instance variables' do
      get :index

      expect(assigns(:user)).to eq(user)
      expect(assigns(:missing_foods)).to eq(missing_foods)
      expect(assigns(:total_food_items)).to eq(2)
      expect(assigns(:total_price)).to eq(25.99)
      expect(assigns(:result)).to eq({
                                       missing_items: 2,
                                       total_price: 25.99,
                                       items: [
                                         { name: 'Food 1', quantity: 2, measurement_unit: 'kg', price: 12.99 },
                                         { name: 'Food 2', quantity: 1, measurement_unit: 'piece', price: 13.00 }
                                       ]
                                     })
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'private methods' do
    describe '#calculate_total_price' do
      it 'calculates the total price of foods' do
        foods = [double('Food', price: 10.99), double('Food', price: 15.00)]
        total_price = controller.send(:calculate_total_price, foods)
        expect(total_price).to be_within(0.01).of(25.99)
      end
    end
  end
end
