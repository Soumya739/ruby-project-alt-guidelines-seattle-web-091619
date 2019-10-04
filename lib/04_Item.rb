class Item < ActiveRecord::Base
    has_many :ordered_items
    has_many :orders, through: :ordered_items
    belongs_to :store
end