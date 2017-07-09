#!/usr/bin/env ruby
require 'pry'
require 'fileutils'

OUTPUT_DIR = './content/recordings'
RECORDINGS_DIR = './recordings'
DAY_TEMPLATE = './templates/day.html'
MONTH_TEMPLATE = './templates/month.html'
YEAR_TEMPLATE = './templates/year.html'
RECORDINGS_TEMPLATE = './templates/recordings.html'

recordings_by_date = Dir.glob("#{RECORDINGS_DIR}/*.yaml").sort {|x,y| y <=> x }

def copy_template(dir_part,day_part,template)
  month_part = day_part.split('/')[0..-2].join('/')
  year_part = day_part.split('/')[0..-3].first
  full_path = File.join(OUTPUT_DIR, dir_part)
  lines = IO.readlines(template)
  content = lines.insert(0, "<% day_part = \"#{ day_part }\" %>\n")
  content = lines.insert(0, "<% month_part = \"#{ month_part }\" %>\n")
  content = lines.insert(0, "<% year_part = \"#{ year_part }\" %>\n")
  puts "===> Creating template at #{full_path}.html"
  File.open("#{full_path}.html", 'w+') do |file|
    file.write(content.join)
  end
end

def copy_yaml(yaml_files)
  yaml_files.each do |file|
    destination = File.dirname(file.gsub(/(\d{4})-(\d{2})-(\d{2})-/,'\1/\2/\3/'))
    destination = File.join('content', destination, file.gsub('./recordings/',''))
    puts "Moving #{file} => #{destination}"
    FileUtils.cp(file, destination)
  end
end

def process_group(date_part, rec_group, template)
  day_part = File.dirname(rec_group.first.gsub('-', '/').gsub('./recordings',''))
  day_part = day_part.scan(/\d{4}\/\d{2}\/\d{2}/).first
  dir_part = date_part.first.gsub('-','/')
  puts "dir_part: #{dir_part} day_part: #{day_part} date_part: #{date_part}"
  FileUtils.mkdir_p(File.join(OUTPUT_DIR, dir_part))
  copy_template(dir_part,day_part,template)
end

def process_days(recordings)
  recordings.group_by {|x| x.scan(/\d{4}-\d{2}-\d{2}/) }.each do |date_part, rec_group|
    process_group(date_part, rec_group, DAY_TEMPLATE)
    copy_yaml(rec_group)
  end
end

def process_months(recordings)
  recordings.group_by {|x| x.scan(/\d{4}-\d{2}/) }.each do |date_part, rec_group|
    process_group(date_part, rec_group, MONTH_TEMPLATE)
  end
end

def process_years(recordings)
  recordings.group_by {|x| x.scan(/\d{4}/) }.each do |date_part, rec_group|
    process_group(date_part, rec_group, YEAR_TEMPLATE)
  end
end

def process_recordings_page(recordings)
  day_part = File.dirname(recordings.first.gsub('-', '/').gsub('./recordings',''))
  day_part = day_part.scan(/\d{4}\/\d{2}\/\d{2}/).first
  puts "day_part: #{day_part}"
  month_part = day_part.split('/')[0..-2].join('/')
  year_part = day_part.split('/')[0..-3].first
  full_path = './content/recordings'
  lines = IO.readlines(RECORDINGS_TEMPLATE)
  content = lines.insert(0, "<% day_part = \"#{ day_part }\" %>\n")
  content = lines.insert(0, "<% month_part = \"#{ month_part }\" %>\n")
  content = lines.insert(0, "<% year_part = \"#{ year_part }\" %>\n")
  puts "===> Creating template at #{full_path}.html"
  File.open("#{full_path}.html", 'w+') do |file|
    file.write(content.join)
  end
end



process_days(recordings_by_date)
process_months(recordings_by_date)
process_years(recordings_by_date)
process_recordings_page(recordings_by_date)
