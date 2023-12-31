class RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = Recipe.includes([:user]).where(user_id: current_user.id).order(created_at: :desc)
  end

  def public_recipes
    @recipes = Recipe.includes(:user, :foods).where(public: true).order(created_at: :desc)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @user = current_user
    @recipe_foods = RecipeFood.includes(:recipe).where(recipe_id: @recipe.id)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    if @recipe.save
      flash[:notice] = 'Saved Successfully'
      redirect_to recipes_path
    else
      flash[:alert] = 'Failed to save!'
      render :new
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])

    if @recipe.destroy
      flash[:notice] = 'Deleted Successfully'
    else
      flash[:alert] = 'Failed to delete!'
    end
    redirect_to recipes_path
  end

  def toggle_public
    @recipe = Recipe.find(params[:id])
    @recipe.update(public: !@recipe.public)
    redirect_to recipe_path(@recipe)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description)
  end
end
