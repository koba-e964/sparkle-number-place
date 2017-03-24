import org.opencv.core.Core;
import org.opencv.imgcodecs.Imgcodecs;


public class Main {
  public static void main(String[] args){
    System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    System.out.println("\n----[WIP]Sudoku Detection----\n");
    
    //error handle pls.
    new NumberPlayScanner(Imgcodecs.imread("data/sudoku.png")).run();
    
    System.out.println("End of main\n");
  }
}
