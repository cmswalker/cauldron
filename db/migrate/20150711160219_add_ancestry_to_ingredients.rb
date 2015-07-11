class AddAncestryToIngredients < ActiveRecord::Migration
  def change
  	add_column :ingredients, :ancestry, :string
  	add_index(:ingredients, :ancestry)
  	remove_index(:ingredients, :ancestry) 
  end
end
