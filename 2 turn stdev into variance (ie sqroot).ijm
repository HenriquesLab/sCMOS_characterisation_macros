input = "K:/sCMOS characterisation/"    //path input
prefix="STD"
processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + list[i])){
			processFolder("" + input + list[i]);
		}
		else{
			if(startsWith(list[i], prefix)){
				processFile(input, list[i]);
			}
		}
	}
}

function processFile(input, file) {	

setBatchMode(true);
fullpath=input+file;
	if(startsWith(file, prefix)){
		print(fullpath);
		open(fullpath);
		selectImage(file);
		title = getTitle();
		path = getDirectory("image");
		v = "Var - ";
		variance = v+title;
		selectImage(title);
		run("Duplicate...", "duplicate");
		run("32-bit");
		run("Square Root", "stack");
		saveAs("Tiff", path+variance);	
		selectImage(title);
		close();
		selectImage(variance);
		close();
		print("done yay");
	}
}