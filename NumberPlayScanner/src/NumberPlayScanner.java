import java.util.ArrayList;
import java.util.List;

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfKeyPoint;
import org.opencv.core.MatOfPoint;
import org.opencv.core.Point;
import org.opencv.core.Rect;
import org.opencv.core.Scalar;
import org.opencv.core.Size;
//import org.opencv.features2d.FeatureDetector;
//import org.opencv.features2d.Features2d;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

public class NumberPlayScanner{
  Mat image;
  Mat grayscaleImage;
  Mat binImage;
  Mat boundaryDeletedImage;
  
  List<MatOfPoint> contours;
  Mat hierarchy;
  List<Point> sudokuPoints;
  
  MatOfKeyPoint detectedPoints;
  
  public NumberPlayScanner(Mat image){
    this.image = image;
    this.grayscaleImage = new Mat();
    this.binImage = new Mat();
    this.boundaryDeletedImage = new Mat();
    
    this.contours = new ArrayList<MatOfPoint>();
    this.hierarchy = new Mat();
    
    this.detectedPoints = new MatOfKeyPoint();
  }
  
  public void run(){
    imageBinarization();
    
    contourDetection();
    
    boundaryDeletion();
    
    divideCells();
  }
  
  private void imageBinarization(){
    Imgproc.cvtColor(this.image, grayscaleImage, Imgproc.COLOR_RGB2GRAY);
    
    //obtain an image easier to do image processing by gaussian blur
    Imgproc.GaussianBlur(this.grayscaleImage, this.grayscaleImage, new Size(5, 5), 1, 1);
    
    //Adaptive thresholding is used. Need to find most appropriate number for the last two ints of inputs
    Imgproc.adaptiveThreshold(this.grayscaleImage, this.binImage, 255,
                              Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C, Imgproc.THRESH_BINARY, 7, 10);
    Core.bitwise_not(this.binImage, this.binImage);
    Imgproc.dilate(this.binImage, this.binImage, new Mat());
    
    //debug process for binary image
    writeImage(this.grayscaleImage, "output/grayscale.png");
    writeImage(this.binImage, "output/binary.png");
  }
  
  private void contourDetection(){
    Mat contourDetectedImage = this.image.clone();
    //copy and paste code, working fine currently. Should look into it to find better suited logic
    Imgproc.findContours(this.binImage, this.contours, this.hierarchy,
                         Imgproc.RETR_EXTERNAL, Imgproc.CHAIN_APPROX_TC89_L1);
    
    //debug process for contour detection
    Imgproc.drawContours(contourDetectedImage, this.contours, -1, new Scalar(0, 0, 255), 3);
    writeImage(contourDetectedImage, "output/detectedContours.png");
    
    System.out.println(String.format("%d\n", this.contours.size()));
    for(int i = 0; i < this.contours.size(); i++){
      System.out.println("" + this.contours.get(i).dump());
    }
    
    //currently assuming that there is only one contour in the scene.
    this.sudokuPoints = this.contours.get(0).toList();
    for(int i = 0; i < this.sudokuPoints.size(); i ++){
      System.out.println(String.format(("x:%f, y:%f"), this.sudokuPoints.get(i).x, this.sudokuPoints.get(i).y));
    }
  }
  
  //adjust the sudoku board straight so that it can be easily handled later
  private void boardAdjustment(){
    
  }
  
  //Delete boundaries in order not to hinder number recognition later
  private void boundaryDeletion(){
    Mat mask = new Mat();
    this.boundaryDeletedImage = this.binImage.clone();
    
    Imgproc.floodFill(this.boundaryDeletedImage, mask, this.sudokuPoints.get(0), new Scalar(0,0,0));
    
    writeImage(this.boundaryDeletedImage, "output/boundaryDeletedImage.png");
  }
  
  //divide the detected board into 9x9 sudoku problem to detect numbers in it
  private void divideCells(){
    Core.bitwise_not(this.boundaryDeletedImage, this.boundaryDeletedImage);
    double x1 = Math.pow(10, 10), x2 = 0, y1 = Math.pow(10, 10), y2 = 0;
    
    for(int i = 0; i < this.sudokuPoints.size(); i++){
      x1 = Math.min(x1, this.sudokuPoints.get(i).x);
      x2 = Math.max(x2, this.sudokuPoints.get(i).x);
      y1 = Math.min(y1, this.sudokuPoints.get(i).y);
      y2 = Math.max(y2, this.sudokuPoints.get(i).y);
    }
    double width = (x2 - x1) / 9, height = (y2 - y1) / 9;
    
    Point upperLeft = new Point(x1, y1);
    double h = 0;
    for(int i = 0; i < 9; i++){
      h += height;
      for(int j = 0; j < 9; j++){
        Point cell = new Point(upperLeft.x + width, upperLeft.y + height);
        Rect r = new Rect(upperLeft, cell);
        
        String filename = "output/trim/cell" + (j+1) + "x" + (i+1) + ".png";
        //image trimming by Rectangle r
        Mat dividedImage = new Mat(this.boundaryDeletedImage, r);
        Imgcodecs.imwrite(filename, dividedImage);
        upperLeft.x = cell.x;
      }
      upperLeft.x = x1;
      upperLeft.y = y1 + h;
    }
  }
  
  private void writeImage(Mat outputImage, String path){
    //debug process
    System.out.println(String.format("Write %s\n", path));
    Imgcodecs.imwrite(path, outputImage);
  }
  
//  currently not in use
//  private void cornerDetection(){
//    FeatureDetector fast = FeatureDetector.create(FeatureDetector.DYNAMIC_FAST);
//    fast.detect(this.grayscaleImage, this.detectedPoints);
//    
//    Mat cornerDetectedImage = new Mat();
//    
//    Features2d.drawKeypoints(image, this.detectedPoints, cornerDetectedImage, new Scalar(0, 0, 255), 0);
//    
//    writeImage(cornerDetectedImage, "output/cornerDetectedImage.png");
//  }
}
