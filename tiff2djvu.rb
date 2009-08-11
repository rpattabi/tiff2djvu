#!/usr/local/bin/shoes

=begin
To do
=====
1. Fix Lazy update (Progress text appears after program completes)
2. Gui Fixes (resize text box etc)
3. Jpeg, png files
4. Cleanup section. create subfolders, move temp/output files to subfolders

FRs:
* Fix: File name assumptions (Scan_BW etc)
	- get rid of assumptions, or
	- User input: pattern for mono and colour images and option to process either or both.
* Select some files to convert
* Output folder, temp folder
* Checkboxes for optionally creating png, jpeg images

+++++

notes:
* ImageMagick library (ruby) available.
* Any format (png, jpeg,etc  not just tif) to DjVu?
* http://www.howtoforge.com/creating_djvu_documents_on_linux



=end


Shoes.app :title => "Tiff to Djvu" do

stack do
	flow do
		para "Folder: "
		@source_folder = edit_line :width=>'70%'

		button "browse" do
			@source_folder.text = ask_open_folder
		end

	end
end

button "start" do
	@verbose.text ="Tiff files in " + @source_folder.text + "\n"
	stack do
		Dir.foreach(@source_folder.text) do |file|
			if File.extname(file) == '.tif' or '.tiff'

				@verbose.text += "\nInspecting  :"<< file << "\n" 

				base = File.basename(file, File.extname(file))
				source_tiff = "#{@source_folder.text}/#{file}"
				target_djvu = "#{@source_folder.text}/#{base}.djvu"  

				if file =~ /_BW_/
					@verbose.text += "\tConverting to monochrome djvu..."
					`cjb2 #{source_tiff} #{target_djvu}`
					@verbose.text += "DONE\n"

# elsif really needed?, if not BW, we are converting the remaining stuff to colour anyway?

				elsif file =~ /Scan_Gray_/ || file =~ /IMG_/
					@verbose.text += "\tConverting to colour djvu..."
					ppm = "#{@source_folder.text}/#{base}.ppm"

					`convert #{source_tiff} #{ppm}`
					`c44 #{ppm} #{target_djvu}`
					@verbose.text += "DONE\n"
				end
#			@verbose.text += "Generating jpeg and png files..."
#			`convert #{@source_folder}/#{file} #{@source_folder}/#{base}.jpg`
#			`convert #{@source_folder}/#{file} #{@source_folder}/#{base}.png`
#			@verbose.text += "DONE\n"
			end
		end
	end
alert "All done!"
end

@verbose=edit_box :width=>'100%', :height=>'70%'

=begin
require 'fileutils'
include FileUtils

@verbose.text += "Cleaning up. moving files to subfolders..."

FileUtils.mkdir %w( tmp djvu jpg png )
FileUtils.move Dir.glob('*.djvu'), 'djvu'
FileUtils.move Dir.glob('*.ppm'), 'tmp'
FileUtils.move Dir.glob('*.jpg'), 'jpg'
FileUtils.move Dir.glob('*.png'), 'png'
@verbose.text += "DONE\n"
=end

button "about" do
	window :title => "about" do
		stack do
		title "Tiff 2 Djvu Converter"
		subtitle "Written by Ragu-Anu, June 2009"
		para "Name your Black-and-white Tiff images as Scan_BW_xxxxx.tif, and colour images as IMG_xxxx.tif"
		end
	end
end #button about


end  # shoes
