class Ingredient < ActiveRecord::Base

	has_ancestry
	belongs_to :chart
	# has_and_belongs_to_many :ingredients
	belongs_to :parent, :class_name => "Ingredient", :foreign_key => "parent_id"
	has_many :children, :class_name => "Ingredient", :foreign_key => "parent_id"

	validates :name, presence: true

	# def self.json_tree(nodes)
	#     nodes.map do |node, sub_nodes|
	#       {:name => node.name, :id => node.id, :children => Ingredient.json_tree(sub_nodes).compact}
	#     end
	# end

	def self.arrange_as_array(options={}, hash=nil)                                                                                                                                                            
	    hash ||= arrange(options)

	    arr = []

	    hash.each do |node, children|
	      arr << node
	      arr += arrange_as_array(options, children) unless children.empty?
	    end
	    
	    arr
	end


end
