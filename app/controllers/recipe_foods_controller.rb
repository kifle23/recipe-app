class RecipeFoodsController < ApplicationController
  before_action :find_recipe, only: %i[new create edit update]

  def new
    @recipe_food = RecipeFood.new
  end

  def create
    @food_ids = @recipe.recipe_foods.pluck(:food_id)

    if @food_ids.include?(recipe_food_params[:food_id].to_i)
      redirect_to recipe_path(@recipe), alert: 'Recipe already has this ingredient!'
    else
      @recipe_food = @recipe.recipe_foods.build(recipe_food_params)

      if @recipe_food.save
        redirect_to recipe_path(@recipe), notice: 'Ingredient added successfully'
      else
        flash[:alert] = 'Failed to add ingredient'
        render :new
      end
    end
  end

  def edit
    @recipe_food = RecipeFood.find_by(id: params[:id])
  end

  def update
    @recipe_food = RecipeFood.find_by(id: params[:id])

    if @recipe_food.update(recipe_food_params)
      redirect_to recipe_path(@recipe), notice: 'Ingredient updated successfully'
    else
      flash[:alert] = 'Failed to update ingredient'
      render :edit
    end
  end

  def destroy
    @recipe_food = RecipeFood.find_by(id: params[:id])

    if @recipe_food.destroy
      redirect_to recipe_path(id: params[:recipe_id]), notice: 'Ingredient removed successfully'
    else
      redirect_to recipe_path(id: params[:recipe_id]), alert: 'Failed to delete the ingredient'
    end
  end

  private

  def find_recipe
    @recipe = Recipe.find_by(id: params[:recipe_id])
  end

  def recipe_food_params
    params.require(:recipe_food).permit(:quantity, :food_id)
  end
end
