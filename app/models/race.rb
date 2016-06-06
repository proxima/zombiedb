require "sinatra/activerecord"

class Race < ActiveRecord::Base

  has_many :racial_modifier_entries

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :description

  validates_numericality_of :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma, :hpr, :spr, :size, :only_integer => true
  validates_numericality_of :skill_max, :spell_max, :greater_than_or_equal => 5, :less_than_or_equal => 120
  validates_numericality_of :skill_rate, :spell_rate, :experience_rate, :greater_than => 0, :less_than_or_equal => 200
 
end
