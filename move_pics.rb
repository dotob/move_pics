require 'exifr'
require 'fileutils'

for imgFile in Dir.glob("*.{jpg,JPG}") do
	# try exi date first
	imgFileDate = EXIFR::JPEG.new(imgFile).date_time
	# then filedate
  imgFileDate ||=	File.new(imgFile).mtime
	if imgFileDate
		create_dir_and_move(imgFileDate, imgFile) 
	else
	  puts "not date in #{imgFile}"
	end
end

def create_dir_and_move (imgFileDate, imgFile)
		dateString = imgFileDate.year.to_s + "_" + sprintf("%02d", imgFileDate.month)
		unless File.directory? dateString
			Dir.mkdir dateString 
			puts "created dir #{dateString}" 
		end
		puts "#{imgFile}  >>  #{dateString}"
		FileUtils.mv(imgFile, dateString+"/"+imgFile)
end

