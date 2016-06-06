require "sinatra/activerecord"

class LevelCost < ActiveRecord::Base
  validates_presence_of :cost
  validates_numericality_of :cost, :only_integer => true
end
