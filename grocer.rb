def find_item_by_name_in_collection(name, collection)
  # collection is an AoH like this [index]{:item => "AVOCADO", :price => 3.00, :clearance => true}
  # name is a string
  
  i=0
  while i < collection.length do
    if name == collection[i][:item]
      return collection[i] #return matching hash if found
    end # if statment
    i += 1 
  end #while loop
  nil # return nil if no match found
end


def find_match(key, array)
  i=0
  while i < array.length do
    if array[i][:name] == key
      return true
    end #if
  end #while
  nil
end

def consolidate_cart(cart)
  # cart is an AoH like this: [index]{:item => "AVOCADO", :price => 3.00, :clearance => true, :count => 3}
  # note that :count key may or may not exist. if it doesn't exist, count =1
  # returns and updated cart AoH
  
  updated_cart = []
  i=0
  while i < cart.length do
    if !find_match(cart[i][:name], updated_cart)
      updated_cart << cart[i]
      updated_cart[-1][:count] = 1

    else
      k=0
      while k < updated_cart.length do
        if updated_cart[k][:name] == cart[i][:name]
          updated_cart[k][:count] += 1
        end #if
        k+=1
      end #k while
    end #if/else
    i+=1
  end #i while
  return updated_cart
end #method
    


=begin  
  temp_cart = cart 
  # need to add temp cart because I cannot touch original cart and I need to add the count key to items that don't have it.
  updated_cart = []
  i = 0
  while i < temp_cart.length do
    if !temp_cart[i][:count]
      temp_cart[i][:count] = 1
    end
    puts "temp cart:"
    pp temp_cart
    k=0
    flag = false
    while k < updated_cart.length do
      if temp_cart[i][:item] == updated_cart[k][:item]
        updated_cart[k][:count] += temp_cart[i][:count]
        flag = true
      end # if statement
      k += 1
    end # k while loop
    if flag == false
      updated_cart << temp_cart[i]
    end #if statement
    i += 1
  end # i while loop
  return updated_cart
end #method
=end  



def apply_coupons(cart, coupons)
  # This method **should** update cart
  # cart is a AoH like: [index]{:item => "AVOCADO", :price => 3.00, :clearance => true, :count => 2}
  # coupons is AoH like: [index]{:item => "AVOCADO", :num => 2, :cost => 5.00}
  # this method shold change cart to:
  #           add "W/COUPON" to item string
  #           increase the count of the item with the coupon by appropriate amount
  #           decrease the count of the item where coupon is not applied
  #           for example: AVOCADO = 3 => AVOCADO W/COUPON = 2; AVOCADO = 1
  #updates the cart with the coupons and returns it (it mutates the original AoH)
  
  i=0
  while i < coupons.length do
    k=0
    l=cart.length
    while k < l do
      if coupons[i][:item] == cart[k][:item] && coupons[i][:num] <= cart[k][:count]
         item_name = coupons[i][:item] << " W/COUPON"
         price = coupons[i][:cost] / coupons[i][:num]
         cart << {:item => item_name, 
                  :price => price, 
                  :clearance => cart[k][:clearance], 
                  :count => coupons[i][:num]}
                  
         cart[k][:count] -= coupons[i][:num]
      end # if statement
       
       k += 1
     end # k while loop
  i += 1
end # i while loop
return cart
end # method




def apply_clearance(cart)
  # method applies 20% discount to every item where :clearance => true.
  # cart is a AoH like: [index]{:item => "AVOCADO", :price => 3.00, :clearance => true}
  
  i=0
  while i < cart.length do
    if cart[i][:clearance] 
      cart[i][:price] *= (0.8).round(2) # this may not work
    end # if statement
    i += 1
  end # while loop
  return cart
end # method


def calculate_cart_total(cart)
  i = 0
  cart_total = 0
  while i < cart.length do
    cart_total += cart[i][:price] * cart[i][:count]
    i += 1
  end #while
  if cart_total > 100
    cart_total *= 0.9.round(2)
  end #if
  return cart_total
end #method



def checkout(cart, coupons)
  # desc: consolidate the cart, then apply coupons, then discount the clearance items, then calculate the cart total, including a volume discount if the cart total > 100.
  #return the total after coupons, clearance and volume discount is applied.
  
  puts "coupons:"
  pp coupons
  puts "initial cart:"
  pp cart
  updated_cart = consolidate_cart(cart)
  puts "updated cart:"
  pp updated_cart
  if coupons
    updated_cart = apply_coupons(updated_cart, coupons)
  end #if coupons
  updated_cart = apply_clearance(updated_cart)
  total = calculate_cart_total(updated_cart)
  return total
end
