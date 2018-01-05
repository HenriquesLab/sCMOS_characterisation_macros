input = "Z:/sCMOS characterisation/First set/";    //path input INDIVIDUAL DATASETS!!!
pre = "Var -";
setBatchMode(true);
newImage("Variances 0", "32-bit black", 2048, 2048, 1);
a=0;
processFolder(input);
//saves file after finished with putting all the images together (removes first since it is just a completely black frame
setSlice(1);
run("Delete Slice");
saveAs("Tiff", ""+input+"Variances.tif");
close();


// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + list[i])){
			processFolder("" + input + list[i]);
		}
		if(startsWith(list[i], pre)) {
			a++;
			b=a-1;
			processFile(input, list[i]);
		}	
	}
}

function processFile(input, file) {	
fullpath=input+file;
	if(startsWith(file, pre)){
			print(fullpath);
			open(fullpath);
			selectImage(file);
			title = getTitle();
			path = getDirectory("image");
			selectImage(title);
			//copies the image (easier to automate with substack instead of duplicate function namewise)
			n=nSlices;
			run("Make Substack...", "  slices=1-"+n+"");
			selectImage("Substack (1-"+n+")");
			rename("Copy "+title);
			copy = getTitle();
			selectImage(title);
			close();
			run("Concatenate...", "  title=[Variances "+a+"] image1=[Variances "+b+"] image2=["+copy+"] image3=[-- None --]");
			selectImage("Variances "+a);
			c=nSlices;
			print(c);
			selectImage("Variances "+a);
	}
}