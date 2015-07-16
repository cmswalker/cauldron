class AddMeasamtToIngredients < ActiveRecord::Migration
  def change
  	add_column :ingredients, :meas_amt, :string 
  end
end
