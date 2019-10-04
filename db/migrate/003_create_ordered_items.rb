class CreateOrderedItems < ActiveRecord::Migration[5.2]
    def change
      create_table :ordered_items do |t|
        t.integer :order_id
        t.integer :item_id
      end
    end
  end
  