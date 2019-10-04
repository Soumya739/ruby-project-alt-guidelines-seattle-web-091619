require "pry"

class Input

    def initialize
        @cart = []
    end    

    def enter_app
        puts "  Welcome to Online Shopping!"
        puts "  Are you registered with us? yes/no?"
        login_proc = Proc.new {login}
        signup_proc = Proc.new {signup}
        execute_conditional_logic({"yes" => login_proc, "no" => signup_proc})    
    end

    def execute_conditional_logic(options_hash={})
        response = gets.chomp
        puts ""
        if options_hash.include?(response.downcase)
            options_hash[response.downcase].call
        elsif response.downcase == "quit"
            puts "Thank you!"
            return
        else
            puts "  Enter valid input only, one of '#{options_hash.keys.join(', ')}'"
            execute_conditional_logic(options_hash)   
        end        
    end

    def login
        puts "  To get started, enter your registered Contact number."
        response2 = gets.chomp
        @user_contact = response2
        if response2 == "quit"
            puts "Thank you!!"
            return
        end    
        found_user = User.where(contact_num: response2).take
        if found_user == nil || self.is_positive_number(response2) == false
            puts "  This number is not registered with us!"
            puts "  Enter 'signup' to create a account  or"
            puts "  Enter 'try again' to enter correct number"
            execute_conditional_logic({"signup" => Proc.new {self.signup}, "try again" => Proc.new {self.login}}) 
            return
        end 
        @current_user = found_user   
        @user_id = @current_user.id
        after_login
    end
    
    def signup
        puts "  Create your account. This'll take a minute."
        puts ""
        puts "  Enter your name"
        u_name = gets.chomp
        if u_name == "exit"
            self.enter_app
        elsif u_name == "quit"
            return
        end
        puts ""
        puts "  Enter your Location"
        u_location = gets.chomp
        if u_location == "exit"
            self.enter_app
        elsif u_location == "quit"
            return
        end
        puts ""
        puts "  Enter your contact number"
        u_contact_num = gets.chomp
        found_user = User.where(contact_num: u_contact_num).take
        if found_user != nil || self.is_positive_number(u_contact_num) == false
            puts ""
            puts "  Try another number!"
            puts "  Signup again"
            puts ""
            signup 
            return
        end
        if u_contact_num == "exit"
            self.enter_app
        elsif u_contact_num == "quit"
            return
        end
        User.create(name: u_name, location: u_location, contact_num: u_contact_num)
        puts "  Account successfully created! Going back to login."
        puts ""
        login        
    end

    def is_positive_number(response)
        response !~ /\D/
    end

    def after_login
        puts ""           
        puts "  Enter 'view' to see your order history    or"
        puts "  Enter 'profile' to see your profile       or"
        puts "  Enter 'create' to create a new order      or"
        puts "  Enter 'update' to update your profile     or"
        puts "  Enter 'delete' to delete your profile"
        execute_conditional_logic(
            {
                "view" => Proc.new {self.view_order_history},
                "create" => Proc.new {self.view_all_stores},
                "update" => Proc.new {self.update_profile},
                "delete" => Proc.new {self.delete_profile},
                "profile" => Proc.new {self.view_current_user_profile},
            }
        )
    end

    def view_current_user_profile
        found_user = User.where(contact_num: @user_contact).take
        puts "      Name :               #{found_user.name}"
        puts "      Location :           #{found_user.location}"
        puts "      Contact nummber :    #{found_user.contact_num}"
        self.after_login
    end

    def view_order_history
        puts ""
        all_orders = Order.where(user_id: @user_id)
        all_orders.each do |order| 
            items_in_order = order.items
            t_price = 0.0
            items_in_order.each do |item|
                t_price = t_price + item.price
            end
            puts ""
            puts "  Order id :      #{order.id}]"
            puts "  Ordere date :   #{order.order_date}"
            puts "  Total:          $#{t_price}"
            items_in_order.map do |item|
                puts "  Item: #{item.name}, Price: $#{item.price}"
            end
        end
        if all_orders.length == 0
            puts "You have no previous orders"            
        end
        puts ""
        self.after_login
    end

    def  view_all_stores
        puts "Enter a store number from list below to see the items available in that store."
        @all_stores = Store.all
        i = 0
        @all_stores.map do |store| 
            i+=1
            puts "  #{i}. #{store.name}"
        end
        puts "Enter store number : "
        response5 = gets.chomp
        
        @selected_store = @all_stores[(response5.to_i) -1]
        @selected_store_name = @selected_store.name
        @cart=[]
        self.view_items_in_store
    end
        
    def view_items_in_store
        puts ""
        @store_items = Item.where(store_id: @selected_store.id)
        self.display_items_in_selected_store
        puts "To go to another store enter 'another store'        or"
        puts "To shop items with this store enter 'continue'"
        execute_conditional_logic(
            {
                "another store" => Proc.new {self.view_all_stores},
                "continue" => Proc.new {self.add_items_in_cart},
            }
        )
    end

    def display_items_in_selected_store
        puts "Below is list of all available items in #{@selected_store_name} store."
        i = 0
        @store_items.map do |item| 
            i+=1 
            puts "    #{i}. #{item.name}, price: #{item.price}"
        end 
        puts ""
    end

    def add_items_in_cart
        puts ""
        self.display_items_in_selected_store
        puts "Enter item number to add item to your cart."
        puts "Item number: "
        item_number = gets.chomp
        puts ""
        item = @store_items[(item_number.to_i) -1]
        @cart << item
        puts "Item added."
        puts "Enter 'add more' to add more items to your cart       or"
        puts "Enter 'cart' to view your cart"
        execute_conditional_logic(
            {
                "add more" => Proc.new {self.add_items_in_cart},
                "cart" => Proc.new {self.display_cart},
            }
        )
    end

    def display_cart
        puts ""
        puts "Cart Details ::-"
        puts "Store : #{@selected_store_name}"
        i =0  
        @cart.map do |item| 
            i+=1
        puts "  #{i}. #{item.name},  item_id: #{item.id}, price: #{item.price}"
        end
        puts ""
        puts "Enter 'modify' to modify cart             or"
        puts "Enter 'finalize' to place your order      or"
        execute_conditional_logic(
            {
                "modify" => Proc.new {self.modify_cart},
                "finalize" => Proc.new {self.checkout}
            }
        )
    end

    def modify_cart 
        puts ""
        puts "Enter 'remove' to remove items from cart        or"
        puts "Enter 'add more' to add more items in cart      or"
        execute_conditional_logic(
            {
                "add more" => Proc.new {self.add_items_in_cart},
                "remove" => Proc.new {self.remove_item_from_cart},
            }
        )
    end 

    def remove_item_from_cart
        puts ""
        puts "Enter item number to delete item from your cart."
        i =0  
        @cart.map do |item| 
            i+=1
            puts "  #{i}. #{item.name},     item_id: #{item.id},    price: #{item.price}"
        end    
        puts "Item number: "
        item_number = gets.chomp
        @cart.delete_at((item_number.to_i) - 1)
        self.display_cart
    end 

    def checkout
        puts "Enter 'order' to place your order           or" 
        puts "Enter 'menu' to return to the main menu     or"
        puts "Enter 'quit' to exit from this app." 
        response6 = gets.chomp
        puts ""
        if response6 == "order"
            new_order = Order.create(user_id: @user_id, order_date: Time.new)
            i = 0
            while i < @cart.length do
                OrderedItem.create(order_id: new_order.id, item_id: @cart[i].id)
                i +=1
            end
            puts "Your order has been placed."
            puts "Thank you for shopping with us :)"
            self.after_login
        elsif response6 == "menu"
            self.after_login
        elsif response6 == "quit"
            puts "Thank You!"
            return
        else
            puts "Enter valid input"
            self.checkout
        end
    end

    def update_profile
        puts ""
        puts "What do you want to update? name/contact number/location/exit?"
            response7 = gets.chomp
            puts ""
            if response7 == "name"
                puts "  Enter name"
                new_name = gets.chomp
                @current_user.update(name: new_name)
                puts ""
                puts "  Name updated!!"
                self.after_login
            elsif response7 == "contact number"
                puts "  Enter contact number"
                new_contact = gets.chomp
                @current_user.update(contact_num: new_contact)
                puts ""
                puts "  Contact number updated!!"
                self.login
            elsif response7 == "location"
                puts "  Enter location"
                new_location = gets.chomp
                @current_user.update(location: new_location)
                puts ""
                puts "  Location updated!!"
                self.after_login
            elsif response7 == "exit"
                self.after_login
            else
                puts "Enter valid input"
                self.update_profile
            end
    end

    def delete_profile
        puts ""
        puts "Are you sure, you want to delete your profile? yes/no?"
        response8 = gets.chomp
        if response8 ==  "yes"
            puts "Enter your Contact number"
            cont_num = gets.chomp
            if cont_num == @user_contact
                current_user = User.where(contact_num: cont_num).take
                Order.where(user_id: current_user.id).destroy_all
                current_user.destroy
                puts ""
                puts "Profile Deleted!"
                puts "Sorry to see you go!!!"
                puts ""
                self.enter_app
            elsif cont_num == "exit"
                self.after_login
            else 
                puts "Enter valid contact number"  
                self.delete_profile
            end
        else
            self.after_login
        end
    end

end
