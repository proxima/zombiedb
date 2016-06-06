require "sinatra/activerecord"

class Stat < ActiveRecord::Base
  validates :short_name, :uniqueness => true, :presence => true
  validates :long_name, :uniqueness => true, :presence => true
end
