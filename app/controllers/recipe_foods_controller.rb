class RecipeFoodsController < ApplicationController
  def new
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @recipe_food = RecipeFood.new
  end

  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @food_ids = RecipeFood.where(recipe_id: @recipe.id).map(&:food_id)

    if @food_ids.include?(recipe_food_params[:food_id].to_i)
      return redirect_to recipe_path(@recipe.id),
                         alert: 'Recipe already has this ingredient!'
    end

    @recipe_food = RecipeFood.new(recipe_food_params)
    @recipe_food.recipe_id = @recipe.id

    if @recipe_food.save
      flash[:notice] = 'Ingredients added successfully'
    else
      flash[:alert] = 'Failed to add Ingredients!'
    end
    redirect_to recipe_path(@recipe)
  end

  def edit
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @recipe_food = RecipeFood.includes(:recipe).find_by(id: params[:id])
  end

  def update
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @recipe_food = RecipeFood.includes(:recipe).find_by(id: params[:id])
    puts @recipe

    if @recipe_food.update(recipe_food_params)
      flash[:notice] = 'Ingredient has been updated successfully'
      redirect_to recipe_path(@recipe.id)
    else
      flash[:alert] = 'Failed to update Ingredient!'
      redirect_to recipe_path(@recipe)
    end
  end

  def destroy
    @recipe_food = RecipeFood.includes(:recipe).find_by(id: params[:id])

    if @recipe_food.destroy
      flash[:notice] = 'Ingedrient removed successfully.'
    else
      flash[:alert] = 'Failed to delete the ingredient!'
    end
    redirect_to recipe_path(id: params[:recipe_id])
  end

  private

  def recipe_food_params
    params.require(:recipe_food).permit(:quantity, :food_id)
  end
end
