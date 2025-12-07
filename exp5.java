import java.util.LinkedList;
import java.util.Queue; 
import java.util.Random;
import java.util.Scanner;

class SlidingWindowProtocol
 {
 private int windowSize;
 private int numFrames;
 private Queue<Integer> window;
 
  public SlidingWindowProtocol(int windowSize, int numFrames)
 {
 this.windowSize = windowSize;
 this.numFrames = numFrames;
 this.window = new LinkedList<>();
 }
 
 public void sendFrames()
{
int currentFrame = 1; 
Random random = new Random(); 


while (currentFrame <= numFrames) 

 {
 while (window.size() < windowSize && currentFrame <= numFrames)
 
 {
  System.out.println("Sending Frame " + currentFrame);
   window.add(currentFrame);
   currentFrame++; 
  }
  
 if (!window.isEmpty()) 

{
 int ackFrame = window.peek();
 boolean isLost = random.nextBoolean();  
 
 if (isLost) 
 {
 System.out.println("ACK for Frame " + ackFrame + " lost.Retransmitting window..."); 
retransmitWindow(); 
}
 else 
 {
 System.out.println("ACK received for Frame " + ackFrame); 
 window.poll(); 
 }
 }
 }
 System.out.println("All frames sent successfully.");
 }
private void retransmitWindow() 
 {
 for (int frame : window) 
 {
 System.out.println("Retransmitting Frame " + frame);
 }
}
 public static void main(String[] args){
 Scanner scanner = new Scanner(System.in);
 System.out.print("Enter the number of frames to be sent: ");
 int numFrames = scanner.nextInt();
 System.out.print("Enter the window size: ");
 int windowSize = scanner.nextInt();
 SlidingWindowProtocol protocol = new
SlidingWindowProtocol(windowSize, numFrames);
 protocol.sendFrames();
 }
 }
