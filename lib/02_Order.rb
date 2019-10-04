class Order < ActiveRecord::Base
    belongs_to :buyer
    has_many :ordered_items
    has_many :items, through: :ordered_items
end