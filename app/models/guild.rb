require "sinatra/activerecord"

class Guild < ActiveRecord::Base

  has_many :skill_train_specs, :order => 'level ASC', :dependent => :destroy
  has_many :spell_train_specs, :order => 'level ASC', :dependent => :destroy

  validates_presence_of :name, :levels
  validates_uniqueness_of :name

  validates_numericality_of :levels, :only_integer => true 
end
