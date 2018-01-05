//CHANGE CODE AS NEEDED IN INDICATED PLACES


input = "Z:/sCMOS characterisation/";    //path input
prefix="Means"; //change to "Var-" when doing variences
processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + list[i]))
			processFolder("" + input + list[i]);
		if(startsWith(list[i], prefix))
			processFile(input, list[i]);
	}
}

function processFile(input, file) {	
setBatchMode(true);
fullpath=input+file;
	if(startsWith(file, prefix)){    //fix respectively
		print(fullpath);
		open(fullpath);
		selectImage(file);
		title = getTitle();
		path = getDirectory("image");
		N = nSlices;
		H = getHeight();
		W = getWidth();
		v="MM-";  //change to MV for means of variences as needed
		newImage(v+title, "32-bit", W, H, 1); 
		selectImage(title);
		for(h = 0; h < H; h++) {
			for(w = 0; w < W; w++) {
				ar = newArray(N);    //indexes for arrays go from 0 to n-1!!!!
				for (n = 1; n <= N; n++) {
					selectImage(title);
					setSlice(n);
					px = getPixel(w,h);
					m=n-1;
					ar[m]=px;
				}
				sum=0;
				for(b=0; b < N; b++) {
				sum = sum+ar[b];
				}
				mean=sum/N;
				selectImage(v+title);
				setPixel(w, h, mean);
			}
		}
		selectImage(title);
		close();
		selectImage(v+title);
		v=getTitle();
		saveAs("Tiff", path+v);
		selectImage(v);
		close();
		print("next");
	}
}