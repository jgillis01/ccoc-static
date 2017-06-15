#!/usr/bin/env ruby

require 'pry'
require 'fileutils'

OUTPUT_DIR = './content/recordings'
MONTH_TEMPLATE = './recordings/month.html'
DAY_TEMPLATE = './recordings/day.html'

def create_output_destination(files)
  files.each do |file|
    destination = file.gsub(/(\d{4})-(\d{2})-(\d{2})-/,'\1/\2/\3/')
    dir = File.dirname(destination)
    FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
    output_path = File.join('./content', destination)
    puts "#{file}: #{output_path}"
    FileUtils.cp(file, output_path)
  end
end

def copy_templates(files, pattern, template)
  pattern = Regexp.new(pattern)
  puts pattern.inspect
  paths = files.map {|x| x.scan(pattern).first.gsub("-", "/") }.uniq
  full_paths = paths.map {|path| File.join(OUTPUT_DIR, path) }

  full_paths.each do |path|
    puts "#{template}: #{File.join(path, 'index.html')}"
    FileUtils.cp(template, File.join(path, 'index.html'))
  end

end

files = Dir.glob('./recordings/*.yaml').sort {|x, y| y <=> x }
create_output_destination(files)
copy_templates(files, '\d{4}-\d{2}', MONTH_TEMPLATE)
copy_templates(files, '\d{4}-\d{2}-\d{2}', DAY_TEMPLATE)
