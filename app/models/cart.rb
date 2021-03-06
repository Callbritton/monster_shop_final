class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += subtotal_of(item_id)
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    count_of(item_id) * item_price(item_id)
  end

  def item_price(item_id)
    if find_discount(item_id) != nil
      Item.find(item_id).price * ((100.0 - find_discount(item_id)) / 100)
    else
      Item.find(item_id).price
    end
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def find_discount(item_id)
    item = Item.find(item_id)
    item.merchant.discounts.where("? >= minimum_quantity", count_of(item_id)).order(percent: :desc).limit(1).pluck(:percent).first
  end

  def discount_name(item_id)
    item = Item.find(item_id)
    item.merchant.discounts.where("? >= minimum_quantity", count_of(item_id)).order(:percent).last.name
  end
end
