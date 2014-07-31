#!/usr/bin/env ruby
require 'exifr'
require 'fileutils'

@just_fake_it = ARGV.include?("-s")
@msg = ""
if @just_fake_it
	@msg = " >> HEY I AM JUST FAKING!!"
end

def doit
  for imgFile in Dir.glob("*.{jpg,JPG}") do
    # try exi date first
    imgFileDate = EXIFR::JPEG.new(imgFile).date_time
    # then filedate
    imgFileDate ||= File.new(imgFile).mtime
    if !imgFileDate.nil?
      create_dir_and_move(imgFileDate, imgFile) 
    else
      puts "not date in #{imgFile}"
    end
  end
end

def create_dir_and_move (imgFileDate, imgFile)
  if imgFileDate.respond_to?(:year)
    dateString = imgFileDate.year.to_s + "_" + sprintf("%02d", imgFileDate.month)
    unless File.directory? dateString
      Dir.mkdir dateString if !@just_fake_it 
      puts "created dir #{dateString} #{@msg}" 
    end
    move_but_do_not_override(imgFile, dateString+"/"+imgFile)
  end
end

def move_but_do_not_override (imgFile, destination)
  if File.exists?(destination)
    puts "#{imgFile}  NOT MOVED, WOULD OVERRIDE #{@msg}"
  else
    puts "#{imgFile}  >>  #{destination} #{@msg}"
    FileUtils.mv(imgFile, destination) if !@just_fake_it
  end
end

doit
