input = "D:/Work/PhD/2nd rotation/Data/playing around/test again/subfolder test/"    //path input
suffix="0.ome.tif" //this is just the ending of the images the way the LLS programm had saved them
processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, list[i]);
	}
}

//actual function
function processFile(input, file) {	
		cat="/"; //so Bio-Formats has a different way of writing the path than ImageJ... and I have to replace a "\\" with a "/"...
		banana = replace(input, cat, "\\\\\\\\"); //and on top of that "\\" is a meaningful symbol so this is the only way to do it.
		print(banana);
		setBatchMode(true);	
		run("Bio-Formats Importer", "open=["+banana+file+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		selectImage(file);
		title = getTitle();
		run("Grouped Z Project...", "projection=[Average Intensity] group=100");
		selectImage("AVG_"+file);
		saveAs("Tiff", input+"AVG_"+file);
		close("AVG_"+title);
		selectImage(title);
		run("Grouped Z Project...", "projection=[Standard Deviation] group=100");
		selectImage("STD_"+file);
		saveAs("Tiff", input+"STD_"+file);
		close("STD_"+title);
		close(title);
		setBatchMode(false);
		print("done");
}
