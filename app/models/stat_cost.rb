require "sinatra/activerecord"

class StatCost < ActiveRecord::Base
  validates_presence_of :cost
  validates_numericality_of :cost, :only_integer => true
end
