class RemoveParentAndChildrenFromIngredients < ActiveRecord::Migration
  def change
  	remove_column :ingredients, :children
  	remove_column :ingredients, :parent
  end
end
