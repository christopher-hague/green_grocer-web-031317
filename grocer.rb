def consolidate_cart(cart)
  consolidated_cart = {}

  cart.each do |item|
    item.each do |item_name, item_info|
      consolidated_cart[item_name] ||= {}

      if consolidated_cart[item_name][:count].nil?
        consolidated_cart[item_name][:count] = 1
      else
        consolidated_cart[item_name][:count] += 1
      end

      item_info.each do |name, val|
        consolidated_cart[item_name][name] = val
      end
    end
  end

  consolidated_cart
end

def apply_coupons(cart, coupons)
  # for each coupon in coupons arr
  coupons.each do |coupon|

    # create a name var in which to store the coupons item name
    name = coupon[:item]

    # if the num of coupons for an item is greater than or equal to the
    # current cart's count of that item
    if cart[name] && cart[name][:count] >= coupon[:num]

      # if a #{name} W/COUPON key already exists
      if cart["#{name} W/COUPON"]

        # increment the coupon count by one
        cart["#{name} W/COUPON"][:count] += 1
      else

        # create the #{name} W/COUPON key, assigning its count to 1 and
        # its :price equal to its coupon cost
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}

        # set the #{name} W/COUPON's [:clearance] prop to the value at
        # cart[name][:clearance]
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end

      # reduce the cart[name][:count] by the num of coupons supplied
      cart[name][:count] -= coupon[:num]
    end
  end

  # return cart
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance]
      info[:price] = (info[:price] * 0.8).round(1)
    end
  end

  cart
end

def checkout(cart, coupons)
  # consolidate the cart
  cart = consolidate_cart(cart)

  # apply coupons
  cart = apply_coupons(cart, coupons)

  # apply clearance
  cart = apply_clearance(cart)


  result = 0
  cart.each do |name, prop|
    result += prop[:price] * prop[:count]
  end

  result = result * 0.9 if result > 100
  result
end
