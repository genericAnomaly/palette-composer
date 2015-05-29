public class Slider2DReticleView implements ControllerView {
  public void display(PApplet p, Object b) {
    if (b instanceof Slider2D) {
      Slider2D s = (Slider2D) b;
      if (s.isCrosshairs) {
        
        // the actual slider values and getCursorX/Y functions are totes bog'd 'cos they're compensating for cursorWidth and cursorHeight
        // which are protected members and thus effectively immutable. 
        float x = s.getCursorX();
        float y = s.getCursorY();
        //As a result the control has to be bigger than it should be to compensate

        //Restrict the values to a circle in the effective area
        float rangeX = s.getWidth() - s.getCursorWidth();
        float rangeY = s.getHeight() - s.getCursorHeight();
        
        float dX = x - rangeX/2;
        float dY = y - rangeY/2;
        
        float dist = sqrt(dX*dX + dY*dY);
        
        float rad = rangeX/2;
        if (dist > rad) {
          println("dist exceeds rad");
          float theta = atan2(dY, dX);
          dX = rad * cos(theta);
          dY = rad * sin(theta);
          
          x = dX + rad;
          y = dY + rad;
        }

        //Actually draw it
        p.noFill();
        p.stroke(255);
        p.ellipse(x-2, y-2, 4, 4);
        p.stroke(0);
        p.ellipse(x-3, y-3, 6, 6);
      }
    }
  }
}



