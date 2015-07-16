class AddMeasToIngredients < ActiveRecord::Migration
  def change
  	add_column :ingredients, :meas, :string 
  end
end
