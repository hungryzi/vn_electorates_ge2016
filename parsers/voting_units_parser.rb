class String
  def remove(phrase)
    self.gsub(phrase, "")
  end
end

def province?(line)
  line[0].to_i > 0
end

def province_name(line)
  line.remove(/[0-9]*\s?\-\s/).chomp("").strip
end

def province_units_count(line)
  line.remove("Số đơn vị bầu cử là ").remove(".").chomp("").strip
end

def province_members_count(line)
  words_to_numbers(line.remove("Số đại biểu Quốc hội được bầu là ").remove(".").chomp("").strip)
end

def unit?(line)
  line.start_with?("Đơn vị")
end

def unit_name(line)
  line.remove("Đơn vị số ").remove(":").chomp("").strip
end

def unit_area(line)
  line.remove("Gồm ").remove(".").chomp("").strip
end

def unit_members_count(line)
  words_to_numbers(line.remove("Số đại biểu Quốc hội được bầu là ").remove(".").chomp("").strip)
end

def words_to_numbers(words)
  case words
  when 'hai' then 2
  when 'ba' then 3
  when 'sáu' then 6
  when 'bảy' then 7
  when 'tám' then 8
  when 'chín' then 9
  when 'mười' then 10
  when 'mười hai' then 12
  when 'mười ba' then 13
  when 'mười bốn' then 14
  when 'ba mươi' then 30
  else
    raise words
  end
end

require 'csv'

units = []

File.open("./NQ53.txt", "r") do |f|
  current_province = nil

  until f.eof do
    line = f.readline
    if province?(line)
      current_province = province_name(line)
      current_units_count = province_units_count(f.readline) # not used
      current_members_count = province_members_count(f.readline) # not used

      current_unit = unit_name(f.readline)
      area = unit_area(f.readline)
      members_count = unit_members_count(f.readline)
    elsif unit?(line)
      current_unit = unit_name(line)
      area = unit_area(f.readline)
      members_count = unit_members_count(f.readline)
    end

    units << [current_province, current_unit, area, members_count]
  end
end

CSV.open("./voting_units.csv", "w") do |csv|
  csv << ["Tỉnh thành", "Đơn vị bầu cử", "Địa phận", "Số ĐBQH"]

  units.each do |u|
    csv << u
  end
end
