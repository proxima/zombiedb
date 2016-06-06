require "sinatra/activerecord"

class LesserWishCost < ActiveRecord::Base
  validates_presence_of :cost
  validates_numericality_of :cost, :only_integer => true
end
