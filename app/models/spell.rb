require "sinatra/activerecord"

class Spell < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_numericality_of :base_cost, :only_integer => true

end
