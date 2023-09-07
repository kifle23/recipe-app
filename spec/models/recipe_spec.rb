require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    it 'should have many foods' do
      expect(Recipe.reflect_on_association(:foods).macro).to eq(:has_many)
    end

    it 'should have many recipe_foods' do
      expect(Recipe.reflect_on_association(:recipe_foods).macro).to eq(:has_many)
    end

    it 'should belong to a user' do
      expect(Recipe.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end
end
