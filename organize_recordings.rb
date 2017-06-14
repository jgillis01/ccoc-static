#!/usr/bin/env ruby

require 'pry'
require 'fileutils'

OUTPUT_DIR = './content/recordings'

files = Dir.glob('./recordings/*.yaml')
month_grouped_files = files.group_by { |x| x.scan(/\d{4}-\d{2}/).first }
months = month_grouped_files.keys.sort {|x,y| y <=> x }

months.each do |month|
  puts ""
  puts "********** #{month} ***********"
  files = month_grouped_files[month].sort {|x,y| y <=> x }
  date_grouped_files = files.group_by { |x| x.scan(/\d{4}-\d{2}-\d{2}/).first }

  date_grouped_files.keys.each do |date|
    date_grouped_files[date].each do |file|
      destination = file.gsub(/(\d{4})-(\d{2})-(\d{2})-/,'\1/\2/\3/')
      dir = File.dirname(destination)
      FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
      puts destination
    end
  end
end



#    selected_files = files.select {|f| ! f.index("#{year}-#{formatted_month}").nil? }
#    unless selected_files.empty?
#
#
#      # Copy files to directories
#      selected_files.each do |file|
#        puts "Copying file: #{file} to #{output_path}"
#        FileUtils.cp(file, output_path)
#      end
#
#      # Copy template index file for directory
#      puts "* Creating index file ./content/recordings/#{year}/#{formatted_month}.html"
#      FileUtils.cp('./recordings/month.html', "./content/recordings/#{year}/#{formatted_month}.html")
#    end
#  end
#end
