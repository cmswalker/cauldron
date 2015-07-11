class AddChildrenToIngredients < ActiveRecord::Migration
  def change
  	add_column :ingredients, :children, :integer 
  end
end
