#!/usr/local/bin/shoes

=begin
BundleDjVus - to Combine individual djvu files in a folder into one single djvu.
Ananth, Aug 11, 2009

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
	flow do
		para "Combined DjVu File name: "
		@outfile = edit_line :width=>'50%'
	end
end #stack

button "start" do
	@verbose.text ="Bundling DjVu files in #{@source_folder.text} \n... as #{@outfile.text}\n"
	@firsttime = true
	stack do
		bundle = "#{@source_folder.text}/#{@outfile.text}" 
		srcfiles=Dir.entries(@source_folder.text).sort
		srcfiles.cycle(1) do |file|
			@verbose.text << "\tInspecting - #{file}\n"
				base = File.basename(file, File.extname(file))
				source = "#{@source_folder.text}/#{file}"
				 
			if File.extname(file) == '.djvu' and source != bundle
				case @firsttime
					when true
						 `djvm -c #{bundle} #{source}`
						@verbose.text << "First page - #{source}\n"
						@firsttime = false
					else
						@verbose.text << "Then -> #{source}\n"
						`djvm -i #{bundle} #{source}`
				end #case
			end #if	
		end #each
	end #stack
	alert("All Done")
	exit()
end #button
@verbose=edit_box :width=>'100%', :height=>'70%'
end #Shoes