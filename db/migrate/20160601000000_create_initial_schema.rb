require_relative('../../lib/parse_zcreator.rb')

class CreateInitialSchema < ActiveRecord::Migration
  def up
    create_table :skill_train_specs do |t|
      t.integer :guild_id
      t.integer :level
      t.integer :max
      t.integer :skill_id
    end

    create_table :skills do |t|
      t.string :name
      t.integer :base_cost
    end

    create_table :spell_train_specs do |t|
      t.integer :guild_id
      t.integer :level
      t.integer :max
      t.integer :spell_id
    end

    create_table :spells do |t|
      t.string :name
      t.integer :base_cost
    end

    create_table :stats do |t|
      t.string :short_name
      t.string :long_name
    end

    Stat.create(short_name: "Str", long_name: "Strength")
    Stat.create(short_name: "Dex", long_name: "Dexteritiy")
    Stat.create(short_name: "Int", long_name: "Intelligence")
    Stat.create(short_name: "Wis", long_name: "Wisdom")
    Stat.create(short_name: "Con", long_name: "Constitution")
    Stat.create(short_name: "Cha", long_name: "Charisma")
    Stat.create(short_name: "Siz", long_name: "Size")

    Stat.create(short_name: "Sp_regen", long_name: "Spell point regeneration")
    Stat.create(short_name: "Hp_regen", long_name: "Hit point regeneration")

    Stat.create(short_name: "PhysRes", long_name: "Physical resistance")
    Stat.create(short_name: "PoisRes", long_name: "Poison resistance")
    Stat.create(short_name: "ColdRes", long_name: "Cold resistance")
    Stat.create(short_name: "MagiRes", long_name: "Magical resistance")
    Stat.create(short_name: "AsphRes", long_name: "Asphyxiation resistance")
    Stat.create(short_name: "AcidRes", long_name: "Acid resistance")
    Stat.create(short_name: "ElecRes", long_name: "Electric resistance")
    Stat.create(short_name: "FireRes", long_name: "Fire resistance")

    create_table :races do |t|
      t.string :name
      t.string :description
      t.integer :strength
      t.integer :dexterity
      t.integer :constitution
      t.integer :intelligence
      t.integer :wisdom
      t.integer :charisma
      t.integer :size
      t.integer :hpr
      t.integer :spr
      t.integer :skill_max
      t.integer :spell_max
      t.integer :skill_rate
      t.integer :spell_rate
      t.integer :experience_rate
    end

    create_table :racial_modifiers do |t|
      t.string :description
      t.string :help_description
    end

    create_table :racial_modifier_entries do |t|
      t.integer :race_id
      t.integer :racial_modifier_id
    end

    create_table :train_costs do |t|
      t.integer :cost
    end

    create_table :level_costs do |t|
      t.integer :cost
    end

    create_table :quest_point_costs do |t|
      t.integer :cost
    end

    create_table :stat_costs do |t|
      t.integer :cost
    end

    create_table :lesser_wish_costs do |t|
      t.integer :cost
    end

    create_table :greater_wish_costs do |t|
      t.integer :cost
    end

    create_table :guilds do |t|
      t.string :name
      t.integer :levels
      t.boolean :primary
    end

    main_guilds, guilds, race_info, train_costs, level_costs, qp_costs, stat_costs, lesser, greater, skills, spells = get_data()

    guilds.each do |k,v|
      g = Guild.new
      g.name = k
      
      stat_bonuses = v.delete :stat_bonuses
      skill_spell = v.delete :skill_spell
      subguilds = v.delete :subguilds
    end
  end

  def down
    drop_table :skill_train_specs
    drop_table :spell_train_specs
    drop_table :races
    drop_table :racial_modifiers
    drop_table :racial_modifier_entries
    drop_table :skills
    drop_table :spells
    drop_table :stats
    drop_table :train_costs
    drop_table :level_costs
    drop_table :quest_point_costs
    drop_table :stat_costs
    drop_table :lesser_wish_costs
    drop_table :greater_wish_costs
    drop_table :guilds
  end
end

