#@ File input

import ij.io.Opener
import ij.ImagePlus

import groovy.util.XmlParser
import ij.gui.PointRoi

Opener opener = new Opener();
ImagePlus imp = opener.openImage('//ad.gatech.edu/bme/labs/ethier-lab/Axon Counting/dataset source files/oldIms+counts/ims/1.png');  
imp.show();  

roi = new PointRoi()

parser = new XmlParser()
doc = parser.parse(input)
doc.Marker_Data.Marker_Type.each {
	x = it.Type[0].text() as int
	print x
	if (x == 1){
	roi.setCounter( it.Type[0].text() as int )
	it.Marker.each {
		roi.addPoint( it.MarkerX[0].text() as int, it.MarkerY[0].text() as int )
	}
}
}
roi.setShowLabels(true)
imp.setRoi(roi)

      
