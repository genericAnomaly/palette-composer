public class MixerUIElement {
  
  Group myGroup;
  
  Textfield vHex;
  Textfield vR, vG, vB;
  Textfield vH, vS, vV;
  
  Button bWheel;
  Slider sValue;
  int wheelSize = 64;
  
  MixerControlListener myListener;
  
  float pH, pS, pV;
  
  
  public MixerUIElement () {
    //TODO
    pH = pS = pV = 1.0;
    buildElement();
  }
  
  private void buildElement() {
    myListener = new MixerControlListener();
    
    myGroup = cp5.addGroup("Palette Mixer");
    myGroup.setBackgroundColor(LAYOUT_COLOR_PANELS);
    myGroup.disableCollapse();
    myGroup.setMoveable(false);


    bWheel = cp5.addButton("Color Wheel");
    bWheel.setImage(generateColorWheel(wheelSize));
    bWheel.updateSize();
    bWheel.setGroup(myGroup);
    bWheel.addListener(myListener);
    
    sValue = cp5.addSlider("Value");
    sValue.setRange(0.0, 1.0);
    sValue.setValue(1.0);
    sValue.setLabelVisible(false);
    sValue.setWidth(wheelSize*2);
    sValue.setGroup(myGroup);
    sValue.addListener(myListener);
    
    vHex = cp5.addTextfield("Hex");
    vR = cp5.addTextfield("Red");
    vG = cp5.addTextfield("Green");
    vB = cp5.addTextfield("Blue");
    vH = cp5.addTextfield("Hue");
    vS = cp5.addTextfield("Sat");
    vV = cp5.addTextfield("Val");
    
    vHex.setGroup(myGroup);
    vR.setGroup(myGroup);
    vG.setGroup(myGroup);
    vB.setGroup(myGroup);
    vH.setGroup(myGroup);
    vS.setGroup(myGroup);
    vV.setGroup(myGroup);
    
    vHex.setSize(50 + LAYOUT_PANEL_PADDING*2, 20);
    vR.setSize(25, 20);
    vG.setSize(25, 20);
    vB.setSize(25, 20);
    vH.setSize(25, 20);
    vS.setSize(25, 20);
    vV.setSize(25, 20);
    
    sortElements();
  }
  
  public void sortElements() {
    //visual colorpicker
    int xValues = LAYOUT_PANEL_PADDING;
    int yValues = LAYOUT_PANEL_PADDING;
    
    bWheel.setPosition(xValues, yValues);
    sValue.setPosition(xValues, yValues + bWheel.getHeight() + LAYOUT_PANEL_PADDING);
    xValues += bWheel.getWidth() + LAYOUT_PANEL_PADDING*2;
    
    vHex.setPosition(xValues, yValues);
    yValues = yValues + vHex.getHeight() + vHex.getValueLabel().getLineHeight() + LAYOUT_PANEL_PADDING*2;
    vR.setPosition(xValues, yValues);
    vH.setPosition(xValues + vR.getWidth() + LAYOUT_PANEL_PADDING*2, yValues);
    yValues = yValues + vR.getHeight() + vR.getValueLabel().getLineHeight() + LAYOUT_PANEL_PADDING + 3;
    vG.setPosition(xValues, yValues);
    vS.setPosition(xValues + vG.getWidth() + LAYOUT_PANEL_PADDING*2, yValues);
    yValues = yValues + vG.getHeight() + vG.getValueLabel().getLineHeight() + LAYOUT_PANEL_PADDING + 3;
    vB.setPosition(xValues, yValues);
    vV.setPosition(xValues + vB.getWidth() + LAYOUT_PANEL_PADDING*2, yValues);
    yValues = yValues + vB.getHeight() + vB.getValueLabel().getLineHeight() + LAYOUT_PANEL_PADDING + 3;
    
  }
  
  public void setSize(int w, int h) {
    //TODO
  }
  
  public PImage generateColorWheel(int radius) {
    return generateColorWheel(radius, 1.0);
  }
  
  public PImage generateColorWheel(int radius, float v) {
    
    //colorMode(HSB, 1.0);
    float h, s;
    
    PImage wheel = createImage(radius*2, radius*2, ARGB);
    wheel.loadPixels();
    
    for (int x=-radius; x<radius; x++) {
      for (int y=-radius; y<radius; y++) {
        float dist = sqrt(x*x+y*y)/radius;
        if (dist > 1) continue;  //comment out for dumb falloff trick
        float theta = atan2(y, x);
        h = ( (theta/(2*PI))+1 ) % 1;
        s = dist;

        //dumb falloff trick
        float fV = v;
        if (dist>1) fV = fV - (dist-1);
        if (fV < 0) fV = 0;

        wheel.pixels[(x+radius) + (y+radius)*(2*radius)] = hsvToRGB(h, s, v); //color(h, s, fV);
      }
    }
    wheel.updatePixels();
    
    //colorMode(RGB, 255);
    return wheel;

  }
  
  
  
  public int hsvToRGB(float h, float s, float v) {
    //Sporked from http://www.easyrgb.com/index.php?X=MATH&H=21#text21
    int r, g, b;
    if (s == 0) {
      r = g = b = (int) v*255;
    } else {
      float var_h = (h * 6) % 6;
      int var_i = floor(var_h);
      
      float var_1 = v * (1 - s);
      float var_2 = v * (1 - s * ( var_h - var_i ) );
      float var_3 = v * (1 - s * ( 1 - (var_h - var_i) ) );

      float var_r, var_g, var_b;
      switch(var_i) {
        case 0:
          var_r = v;
          var_g = var_3;
          var_b = var_1;
          break;
        case 1:
          var_r = var_2;
          var_g = v;
          var_b = var_1;
          break;
        case 2:
          var_r = var_1;
          var_g = v;
          var_b = var_3;
          break;
        case 3:
          var_r = var_1;
          var_g = var_2;
          var_b = v;
          break;
        case 4: 
          var_r = var_3;
          var_g = var_1;
          var_b = v;
          break;
        default:
          var_r = v;
          var_g = var_1;
          var_b = var_2;
          break;
      }
      r = floor(var_r * 255);
      g = floor(var_g * 255);
      b = floor(var_b * 255);
    }
    return color(r, g, b);
  }
  
  
  public void refreshSlider() {
    sValue.setColorForeground(hsvToRGB(pH, pS, pV*0.8+0.2));
    sValue.setColorActive(hsvToRGB(pH, pS, pV*0.6+0.2));
  }
  public void refreshWheel() {
    bWheel.setImage(generateColorWheel(wheelSize, pV));
  }
  
  
  class MixerControlListener implements ControlListener {
    public void controlEvent(ControlEvent theEvent) {
      println("MixerControlEvent fired on " + theEvent.getController());
      if (theEvent.getController() == sValue) {
        pV = sValue.getValue();
        refreshWheel();
        refreshSlider();
      }
      if (theEvent.getController() == bWheel) {
        //getAbsolutePosition() is not working on the Button controller but is working on Groups, gotta do some crunching
        int centerX = floor( bWheel.getParent().getAbsolutePosition().x + bWheel.getPosition().x ) + wheelSize;
        int centerY = floor( bWheel.getParent().getAbsolutePosition().y + bWheel.getPosition().y ) + wheelSize;
        println("centerX = " + centerX + ", centerY = " + centerY);
        println("mouseX = " + mouseX + ", mouseY = " + mouseY);
        int x = mouseX - centerX;
        int y = mouseY - centerY;
        float dist = sqrt(x*x+y*y)/wheelSize;
        println("Trace. x = " + x + ", y = " + y + ", Dist = " + dist);
        if (dist > 1) return;
        float theta = atan2(y, x);
        pH = ( (theta/(2*PI))+1 ) % 1;
        pS = dist;
        refreshSlider();
      }
      //col = (int)theEvent.getController().getValue();
    }
  }
  
}
