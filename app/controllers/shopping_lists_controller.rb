class ShoppingListsController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = current_user

    recipe_foods = @user.recipes.joins(:foods).select('foods.*')
    general_foods = @user.foods

    @missing_foods = recipe_foods - general_foods

    @total_food_items = @missing_foods.count
    @total_price = calculate_total_price(@missing_foods)

    @result = {
      missing_items: @total_food_items,
      total_price: @total_price,
      items: @missing_foods.map do |food|
               { name: food.name, quantity: food.quantity, measurement_unit: food.measurement_unit, price: food.price }
             end
    }
  end

  private

  def calculate_total_price(foods)
    foods.sum(&:price)
  end
end
