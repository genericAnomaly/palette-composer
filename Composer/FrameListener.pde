public class FrameListener extends ComponentAdapter {
  
  public void componentResized(ComponentEvent e) {
    //Work with the pane, not the frame, since sketch vars width and height won't be updated til the next draw loop
    JRootPane pane  = ( (JFrame) e.getSource() ).getRootPane();
    
    //Get the dimensions
    int frameWidth = pane.getWidth();
    int frameHeight = pane.getHeight();
    
    //Sort the UI
    sortUIElements(frameWidth, frameHeight);
  }
  
}
