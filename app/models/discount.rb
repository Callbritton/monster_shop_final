class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name, :percent, :minimum_quantity
end
