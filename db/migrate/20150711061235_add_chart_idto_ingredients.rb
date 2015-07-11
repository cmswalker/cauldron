class AddChartIdtoIngredients < ActiveRecord::Migration
  def change
  	add_column :ingredients, :chart_id, :integer 
  end
end
