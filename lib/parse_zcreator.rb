require('active_support/core_ext/hash/deep_merge')
require('json')

def parse_costs(lines)
  costs = []

  lines.each do |l|
    costs << l.gsub(/\s+/m, ' ').strip.split(" ")[2].to_i
  end

  costs
end

def parse_races(lines)
  races = {}
  
  line_num = 0

  header = []

  lines.each do |l|
    pieces = l.gsub(/\s+/m, '').strip.split(/:/)

    if line_num == 1
      header = pieces
      header[0] = "name"
      header[-1] = "spellcost"
      header[-2] = "skillcost"
      header[-3] = "spellmax"
      header[-4] = "skillmax"
    elsif pieces.size == 15
      race = {}
      (0..pieces.size - 1).each do |i|
        race[header[i]] = pieces[i]
      end
      race_name = l[0..l.index(':')-1].rstrip.downcase
      if race_name[0] == '-'
        race_name = race_name[1..-1]
      end
      race.delete("name")
      races[race_name] = race
    end

    line_num = line_num + 1
  end

  races
end

def extract_stats_strings(line)
  pieces = line.gsub(/\s+/m, ' ').strip.split(" ")
  
  ret = []

  str = ""

  (0..pieces.size-1).each do |i|
    if /[[:upper:]]/.match pieces[i][0]
      if str.size > 0
        ret << str
      end
      str = ""
      next
    end

    if str.size > 0
      str << ' '
    end
    str << pieces[i]    
  end

  ret << str

  return ret
end

def parse_help_races(lines)
  races = {}

  current_race = nil
  found_stats = false

  lines.each do |l|
    if l.index('Help race') == 0
      current_race = l["Help race ".length..-1].downcase.rstrip
      found_stats = false
      races[current_race] = {}
      races[current_race][:help_desc] = []
      races[current_race][:help_modifiers] = [] 
    end

    if !l.index(/_|\/\\/).nil?
      next
    end
  
    next if !l.index("---").nil?

    if !l.index('Strength:').nil?
      found_stats = true
      str_dex = extract_stats_strings l
      races[current_race][:str_string] = str_dex[0]
      races[current_race][:dex_string] = str_dex[1]
    elsif !l.index('Intelligence:').nil?
      int_wis = extract_stats_strings l
      races[current_race][:int_string] = int_wis[0]
      races[current_race][:wis_string] = int_wis[1]
    elsif !l.index('Constitution:').nil?
      con_cha = extract_stats_strings l
      races[current_race][:con_string] = con_cha[0]
      races[current_race][:cha_string] = con_cha[1]
    elsif !l.index('Size:').nil? 
      pieces = l.gsub(/\s+/m, ' ').strip.split(" ")
      str = ""
      (1..pieces.size-1).each do |i|
        if str.size > 0
          str << ' '
        end
        str << pieces[i]
      end
      races[current_race][:size_string] = str
    elsif !found_stats
      races[current_race][:help_desc] << l.rstrip if !l.rstrip.empty?
    else
      races[current_race][:help_modifiers] << l.rstrip if !l.rstrip.empty?
    end
  end

  return races
end

def parse_skill_helps(lines)
end

def parse_spell_helps(lines)
end

def parse_levelcosts(lines)
  costs = []

  lines.each do |l|
    costs << l.to_i
  end
  
  costs
end

def parse_qps(lines)
  costs = []
 
  lines.each do |l|
    costs << l.to_i
  end

  costs
end

def parse_skills(lines)
  skills = []

  lines.each do |l|
    pieces = l.rstrip.split(':')
    skills << [pieces[0], pieces[1].to_i]
  end

  skills
end

def parse_spells(lines)
  spells = []

  lines.each do |l|
    pieces = l.rstrip.split(':')
    spells << [pieces[0], pieces[1].to_i]
  end

  spells
end

def parse_statcosts(lines)
  costs = []

  lines.each do |l|
    costs << l.to_i
  end
end

def parse_wishcosts(lines)
  lesser = []
  greater = []

  lines.each do |l|
    if lesser.size < 9
      lesser << l.to_i
    else
      greater << l.to_i
    end
  end

  return lesser, greater
end

def parse_main_guilds(lines)
  main_guilds = {}
  lines.each do |l|
    pieces = l.split(/ /)
    main_guilds[pieces[0]] = pieces[1].to_i
  end
  main_guilds
end

def parse_guild(lines)
  guild = {
    :stat_bonuses => {},
    :skill_spell => {},
    :subguilds => []
  }

  cur_level = 0
  subguilds = false

  stat_regex = /(.*)\((\d+)\)/

  lines.each do |l|
    md = /\|\s*(\d+)\s\| (.*)\|/.match(l)
    if md and md.size == 3
      cur_level = md[1].to_i
      guild[:stat_bonuses][cur_level] = []
      stat_pieces = md[2].split(", ")
      stat_pieces.each do |sp|
        md2 = stat_regex.match(sp)
        if md2 and md2.size == 3
          stat = md2[1]
          amount = md2[2].to_i
          guild[:stat_bonuses][cur_level] << [stat, amount]
        end
      end
    end

    md = /\|\s{5}\| (.*)\|/.match(l)
    if md and md.size == 2
      stat_pieces = md[1].split(", ")
      stat_pieces.each do |sp|
        md2 = stat_regex.match(sp)
        if md2 and md2.size == 3
          stat = md2[1]
          amount = md2[2].to_i
          guild[:stat_bonuses][cur_level] << [stat, amount]
        end
      end
    end

    md = /Level (\d+) abilities:/.match(l)
    if md and md.size == 2
      cur_level = md[1].to_i
      guild[:skill_spell][cur_level] = []
    end

    md = /May (study|train) (spell|skill) (.*) to (\d+)%/.match(l)
    if md and md.size == 5
      sksp = md[2]
      name = md[3]
      percent = md[4]
      guild[:skill_spell][cur_level] << [sksp, name, percent]
    end

    md = /Subguilds:/.match(l)
    if md
      subguilds = true
    end

    if subguilds
      md = /(.*) (\d+)/.match(l)
      if md and md.size == 3
        sg = [md[1].downcase, md[2].to_i]
        guild[:subguilds] << sg
      end
    end
  end

  guild
end

def get_data()
  files = Dir["../../zCreator_data/data/*.chr"]
  guilds = {}
  help_races = {}
  races = {}
  train_costs = []
  main_guilds = {}
  level_costs = []
  qp_costs = []
  skills = []
  spells = []
  stat_costs = []
  lesser = []
  greater = []

  files.each do |f|
    basename = File.basename(f,File.extname(f))
    lines = IO.readlines(f)

    if basename == "costs"
      # done
      train_costs = parse_costs(lines)
    elsif basename == "guilds"
      # done
      main_guilds = parse_main_guilds(lines)
    elsif basename == "help_races"
      # done
      help_races = parse_help_races lines
    elsif basename == "help_skill"
      # don't
      parse_skill_helps lines
    elsif basename == "help_spell"
      # don't
      parse_spell_helps lines
    elsif basename == "levelcosts"
      # done
      level_costs = parse_levelcosts(lines)
    elsif basename == "questpoints"
      # done
      qp_costs = parse_qps(lines)
    elsif basename == "races"
      # done
      races = parse_races(lines)
    elsif basename == "races OLD"
      # don't
    elsif basename == "skills"
      skills = parse_skills(lines)
    elsif basename == "spells"
      spells = parse_spells(lines)
    elsif basename == "statcost"
      stat_costs = parse_statcosts(lines)
    elsif basename == "wishcost"
      # done
      lesser, greater = parse_wishcosts(lines)
    else
      # done
      guilds[basename] = parse_guild(lines)
    end
  end

  race_info = races.deep_merge(help_races)

  [main_guilds, guilds, race_info, train_costs, level_costs, qp_costs, stat_costs, lesser, greater, skills, spells]
end
