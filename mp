#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'exifr'
require 'fileutils'
require 'awesome_print'

program :version, '0.0.1'
program :description, 'moves pictures by exif/file date into yyyy-mm directories'

default_command :move_pics

command :move_pics do |c|
  c.syntax = 'move_pics move [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--fake', 'just fake moving but tell what would be done'
  c.action do |args, options|
    @just_fake_it = options.fake
    @msg = options.fake ? " >> HEY, I AM JUST FAKING!!" : ""
    doit
  end
end

def doit
  files = Dir.glob("*.{jpg,JPG,jpeg}")
  ap files
  if files.any?
    puts "work on #{files.length} files"
    i = 0
    for imgFile in files do
      # try exif date first
      imgFileDate = EXIFR::JPEG.new(imgFile).date_time
      # then filedate
      imgFileDate ||= File.new(imgFile).mtime
      if !imgFileDate.nil?
        i += create_dir_and_move(imgFileDate, imgFile) 
      else
        puts "not date in #{imgFile}"
      end
    end
    puts "worked on #{i} files"
  else
    puts "nothing to do..."
  end
end

def create_dir_and_move (imgFileDate, imgFile)
  i = 0
  if imgFileDate.respond_to?(:year)
    dateString = imgFileDate.year.to_s + "_" + sprintf("%02d", imgFileDate.month)
    unless File.directory? dateString
      Dir.mkdir dateString if !@just_fake_it 
      puts "created dir #{dateString} #{@msg}" 
    end
    i = move_but_do_not_override(imgFile, dateString+"/"+imgFile)
  else
    puts "image file date was no date: >#{imgFileDate}<, #{imgFileDate.class}"
  end
  i
end

def move_but_do_not_override (imgFile, destination)
  i = 0
  if File.exists?(destination)
    puts "#{imgFile}  NOT MOVED, WOULD OVERRIDE #{@msg}"
  else
    puts "#{imgFile}  >>  #{destination} #{@msg}"
    FileUtils.mv(imgFile, destination) if !@just_fake_it
    i += 1
  end
  i
end

