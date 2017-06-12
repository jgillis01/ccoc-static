#!/usr/bin/env ruby

require 'pry'
require 'fileutils'

OUTPUT_DIR = './content/recordings'
START_YEAR = 2017

files = Dir.glob('./recordings/*.yaml')

START_YEAR.upto(Time.now.year).each do |year|
  last_month = Time.now.year == year ? Time.now.month : 12
  1.upto(last_month) do |month|

    formatted_month = format('%02d', month)
    selected_files = files.select {|f| ! f.index("#{year}-#{formatted_month}").nil? }
    unless selected_files.empty?
      output_path = File.join(File.join(OUTPUT_DIR, year.to_s, formatted_month))

      # Make sure directories exist
      unless Dir.exists?(output_path)
        FileUtils.mkdir_p(output_path)
      end

      # Copy files to directories
      selected_files.each do |file|
        puts "Copying file: #{file} to #{output_path}"
        FileUtils.cp(file, output_path)
      end

      # Copy template index file for directory
      puts "* Creating index file ./content/recordings/#{year}/#{formatted_month}.html"
      FileUtils.cp('./recordings/index.html', "./content/recordings/#{year}/#{formatted_month}.html")
    end
  end
end
