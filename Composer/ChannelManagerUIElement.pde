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
    myGroup = cp5.addGroup("Channel Manager");
    myGroup.setBackgroundColor(LAYOUT_COLOR_PANELS);
    myGroup.disableCollapse();
    myGroup.setMoveable(false);
  }
  
  public void sortElements() {
    //TODO
    if (children != null) {
      int i = 0;
      int y = LAYOUT_SIZE_GUTTER + myGroup.getBarHeight();
      for (ChannelUIElement child : children) {
        child.setPosition(LAYOUT_SIZE_GUTTER, y);
        child.setSize(myGroup.getWidth() - LAYOUT_SIZE_GUTTER*2, 62); //TODO: method for channel to set its own height based on children
        y += child.myGroup.getBarHeight();
        y += LAYOUT_SIZE_GUTTER;
        if (child.myGroup.isOpen()) y += 62; //child.myGroup.getHeight(); <-- same TODO, getHeight doesn't work for some reason
        //println(channelPanel.getName() + " isOpen() = " + channelPanel.isOpen() + ", getHeight() = " + channelPanel.getHeight() );
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
  
  public PaletteUIElement getPaletteUIElement(Toggle t) {
    //Gets the PaletteUIElement that t is in
    //Should /probably/ just extend Toggle to be aware of its parent PaletteUIElement object
    for (ChannelUIElement cuie : children) {
      for (PaletteUIElement puie : cuie.children) {
        if (puie.myToggle == t) return puie;
      }
    }
    return null;
  }
  

  
}
