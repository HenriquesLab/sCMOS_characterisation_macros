//renamed images to A, B, C, D beforehand - easier to handle
//A - xi B - yi C - x mean D - y mean
//x - mean, y - variance
setBatchMode(true);
open("Z:/sCMOS characterisation/First set/1 dark on illu off (I think)/A.tif");
open("Z:/sCMOS characterisation/First set/1 dark on illu off (I think)/B.tif");
open("Z:/sCMOS characterisation/First set/1 dark on illu off (I think)/C.tif");
open("Z:/sCMOS characterisation/First set/1 dark on illu off (I think)/D.tif");
print("opened");
selectImage("A.tif");
N = nSlices;
H = getHeight();
W = getWidth();
path = getDirectory("image");
newImage("Gain.tif", "32-bit", W, H, 1);
saveAs("Tiff", path+"Gain.tif");
newImage("Offset.tif", "32-bit", W, H, 1);
saveAs("Tiff", path+"Offset.tif");
newImage("R2.tif", "32-bit", W, H, 1);
saveAs("Tiff", path+"R2.tif");
arx = newArray(N);    //indexes for arrays go from 0 to n-1
ary = newArray(N);
arsqrx = newArray(N);
arxy = newArray(N);
arx1 = newArray(N);
for(h = 0; h < H; h++) {
	for(w = 0; w < W; w++) {
		for (n = 1; n <= N; n++) {   //fills up xi and yi arrays
			selectImage("A.tif");
			setSlice(n);
			px = getPixel(w,h);
			m=n-1;   //need different variable because n show slice number so cannot be 0
			arx1[m]=px;
			selectImage("B.tif");
			setSlice(n);
			px = getPixel(w,h);
			ary[m]=px;
		}
		selectImage("C.tif");
		x = getPixel(w,h);
		selectImage("D.tif");
		y = getPixel(w,h);
		for (a = 0; a < N; a++) {
			arx[a] = arx1[a]-x;			//fills up xi-x array
			ary[a] = ary[a]-y;			//converts yi array into yi-y array
			arxy[a] = arx[a]*ary[a];	//fills array (xi-x)*(yi-y)
			arx[a] = arx[a]*arx[a];		//converts xi-x array into (xi-x)^2 
			ary[a] = ary[a]*ary[a];		//converts yi-y array into (yi-y)^2
			print("arrays for iteration h="+h+" w="+w+" done");
		}
		for (a = 0; a < N; a++) {
			sumxy += arxy[a];			//sum of (xi-x)*(yi-y)	
			sumsqrx += arx[a];			//sum of (xi-x)^2
			sumsqry += ary[a];			//sum of (yi-y)^2
		}
		b1 = sumxy/sumsqrx;				//b1, i.e. Gain
		b0 = y-b1*x;					//b0, i.e. Offset
		selectImage("Gain.tif");
		setPixel(w,h,b1);
		saveAs("Tiff", path+"Gain.tif");
		selectImage("Offset.tif");
		setPixel(w,h,b0);
		saveAs("Tiff", path+"Offset.tif");
		for (a = 0; a < N; a++) {
			fit = b1*arx1[a]+b0;
			ssr += (fit-y)*(fit-y);
		}
		R2 = ssr/sumsqry;					//R^2
		selectImage("R2.tif");
		setPixel(w,h,R2);
		saveAs("Tiff", path+"R2.tif");
		print("iteration h="+h+" w="+w+" done");
	}
}
selectImage("Gain.tif");
saveAs("Tiff", path+"Gain.tif");
close();
selectImage("Offset.tif");
saveAs("Tiff", path+"Offset.tif");
close();
selectImage("R2.tif");
saveAs("Tiff", path+"R2.tif");
close();
print("done");