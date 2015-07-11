class AddParentToIngredients < ActiveRecord::Migration
  def change
  	add_column :ingredients, :parent, :integer 
  end
end
