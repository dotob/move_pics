require 'exifr'
require 'fileutils'

def create_dir_and_move (imgFileDate, i)
		dateString = imgFileDate.year.to_s + "_" + sprintf("%02d", imgFileDate.month)
		puts i +"  >>  "+ dateString
		if !File.directory? dateString
			Dir.mkdir dateString 
			puts "created dir "+dateString 
		end
		FileUtils.mv(i, dateString+"/"+i)
end


basedir = '.'
files = Dir.glob("*.{jpg,JPG}")

for i in files do
	imgFileDate = EXIFR::JPEG.new(i).date_time
	if imgFileDate
		create_dir_and_move imgFileDate, i 
	else
		imgFileDate = File.new(i).mtime
		if imgFileDate
			create_dir_and_move imgFileDate, i 
		else
	  	puts "not date in "+i
		end
	end
end
