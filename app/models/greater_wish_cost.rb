require "sinatra/activerecord"

class GreaterWishCost < ActiveRecord::Base
  validates_presence_of :cost
  validates_numericality_of :cost, :only_integer => true
end
