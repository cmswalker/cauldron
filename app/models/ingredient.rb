class Ingredient < ActiveRecord::Base

	belongs_to :chart
	has_many :ingredients

	validates :name, presence: true, uniqueness: true


end
