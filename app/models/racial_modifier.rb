require "sinatra/activerecord"

class RacialModifier < ActiveRecord::Base
  validates :description, :uniqueness => true, :presence => true
end
