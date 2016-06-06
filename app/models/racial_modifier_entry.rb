require "sinatra/activerecord"

class RacialModifierEntry < ActiveRecord::Base

  belongs_to :race
  has_one :racial_modifier

end

