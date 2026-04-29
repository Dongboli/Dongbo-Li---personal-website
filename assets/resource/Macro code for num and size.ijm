
SourceDir = getDirectory("C:\\Users\\ek18186\\OneDrive - University of Bristol\\Desktop\\My phd project\\3 Experiments in phd\\Network experiment 2022\\data to run modified\\");
TargetDir = getDirectory("C:\\Users\\ek18186\\OneDrive - University of Bristol\\Desktop\\My phd project\\3 Experiments in phd\\Network experiment 2022\\data to run num results\\");

list = getFileList(SourceDir);
for(i = 15; i<= 15; i++)         ///// how many first folder it has. e.g 0 is the first folder 
 
{
	
list2 = getFileList(SourceDir+list[i]);
	
for(j = 0; j <= 59; j++)      ///// how many subfolders in the first folder. e.g. 100 subfolders 
	{
	list3 = getFileList(SourceDir+list[i]+list2[j]);
		for(k =0; k<= 3; k++)    ///// how many second subsfolders in subfolders. e.g. 4 second subfolders
		{
		subdir = SourceDir + list[i] + list2[j] + list3[k];
		Myoperation(subdir);
		
close();
		
}
	}
}


function Myoperation(subdir) {
	run("Image Sequence...", "open=subdir sort");	       
	title = getTitle();
	
	run("8-bit");
	
	// There's a bit of variation in intensity from frame to frame, which eventually affects the 
	// thresholding.  The histogram-matching bleach correction plugin (Image > Adjust > Bleach Correction)
	// will adjust each frame to match the histogram of the first.
	run("Bleach Correction", "correction=[Histogram Matching]");
	
	// It's useful to pass the image through a filter before thresholding to reduce outliers.  This
	// should give a cleaner segmentation.
	run("Median...", "radius=1 stack");
	
	run("Z Project...", "projection=[Median]");
	imageCalculator("Subtract create stack", "DUP_"+title,"MED_DUP_"+title);
	selectWindow("Result of DUP_"+title);
	
	// For simplicity, I use the auto thresholder plugin.  This can be called using a single line, rather
	// than the three required for the normal thresholder.  I set it to Otsu based on what I expect you
	// want to segment.
	//run("Auto Threshold", "method=Moments white stack");  
///stack use_stack_histogram
    setThreshold(10, 255);
    setOption("BlackBackground", false);
   run("Convert to Mask", "method=Moments background=Dark");

	
	run("Set Measurements...", "area centroid feret's redirect=[DUP_"+title+"] decimal=3");
	run("Set Scale...", "distance=23.8537 known=1 unit=mm");///set scale: 27pixels=1mm
	run("Analyze Particles...", "size=0.04-1.6 circularity=0.00-0.78 show=Nothing summarize stack"); 
    ////circularity=0.00-0.78 
	
	// This will show the outline of the detected objects on the raw (well, nearly-raw, it's after histogram
	// matching and filtering) image.  If you don't want this, just comment out the roiManager and saveAs lines
	///selectWindow("DUP_"+title);
	///roiManager("Show All with labels");
	///saveAs("Tiff", subdir+title);  ////THERE IS AN ERROR ?
	///close();
	
	// This will save the ROIs for each object into a zip archive in the same folder as your input images.  
	// These can be loaded back by dragging the archive into ImageJ.
	///if (roiManager("count") > 0) {
		///roiManager("Save", subdir+title+"_RoiSet.zip");
		///roiManager("reset");
	///}
	
	
	selectWindow("Summary of Result of DUP_"+title);
	saveAs("Results", TargetDir+title+'.csv');
	run("Close");
	
	selectWindow(title);
	close();
	selectWindow("Result of DUP_"+title);
	close();
	selectWindow("MED_DUP_"+title);
	close();
	
}