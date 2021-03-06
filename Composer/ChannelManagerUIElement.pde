public class ChannelManagerUIElement {
  
  ArrayList<ChannelUIElement> children;
  
  Group myGroup;
  
  public ChannelManagerUIElement() {
    buildElement();
  }
  
  public void loadChannels(ArrayList<Channel> channels) {
    //Must disable draw loop when adding elements to the UI. Failure to do so will cause ConcurrentModificationExceptions in the drawing thread
    noLoop();
    
    //TODO: Properly dispose of any existing ChannelUIElements!
    
    //Initialise and populate the children ArrayList
    children = new ArrayList<ChannelUIElement>(channels.size());
    for (Channel c : channels) {
      ChannelUIElement cuie = new ChannelUIElement(c);
      cuie.setGroup(myGroup);
      children.add(cuie);
    }
    
    //Call sortElements to ensure the new elements are laid out properly
    sortElements();
    
    //Re-enable the draw loop
    loop();
  }
  
  private void buildElement() {
    //No noLoop() loop() here because this should only ever be getting called in the PApplet.setup() method
    myGroup = cp5.addGroup("Channel Manager");
    myGroup.setBackgroundColor(LAYOUT_COLOR_PANELS);
    myGroup.disableCollapse();
    myGroup.setMoveable(false);
  }
  
  public void sortElements() {
    if (children != null) {
      int i = 0;
      int y = LAYOUT_PANEL_GUTTER + myGroup.getBarHeight();
      for (ChannelUIElement child : children) {
        child.setPosition(LAYOUT_PANEL_GUTTER, y);
        child.setWidth(myGroup.getWidth() - LAYOUT_PANEL_GUTTER*2);
        y += child.myGroup.getBarHeight();
        y += LAYOUT_PANEL_GUTTER;
        if (child.myGroup.isOpen()) y += child.myGroup.getBackgroundHeight();
      }
    }
  }
  
  public void setSize(int w, int h) {
    myGroup.setSize(w, h);
    sortElements();
  }
  
  public void setPosition(int x, int y) {
    myGroup.setPosition(x, y);
  }
  
  public PaletteUIElement getPaletteUIElement(Button b) {
    //Gets the PaletteUIElement that b is in
    //Should /probably/ just extend Button to be aware of its parent PaletteUIElement object
    if (children == null) return null;
    for (ChannelUIElement cuie : children) {
      if (cuie.children == null) continue;
      for (PaletteUIElement puie : cuie.children) {
        if (puie.myButton == b) return puie;
      }
    }
    return null;
  }
  

  
}
