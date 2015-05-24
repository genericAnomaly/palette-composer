public class ChannelUIElement {
  
  Channel myChannel;
  
  ArrayList<PaletteUIElement> children;
  
  Group myGroup;
  
  public ChannelUIElement(Channel c) {
    myChannel = c;
    
    buildElement();
  }
  
  
  private void buildElement() {
    //Build the containing group
    myGroup = cp5.addGroup(myChannel.name);
    myGroup.setMoveable(false);
    myGroup.setBackgroundColor(LAYOUT_COLOR_CHANNELS);
    myGroup.activateEvent(true);
    
    //TODO: Build optional scrollbar
    
    //Clear children
    //TODO: If it's possible they exist when this function is called, dispose of any existing children
    children = new ArrayList<PaletteUIElement>(myChannel.swaps.size()+1);
    
    //Build the PaletteUIElements
    PaletteUIElement puie = new PaletteUIElement(myChannel, myChannel.base, "base");
    puie.setGroup(myGroup);
    children.add(puie);
    
    int i=0;
    for (Palette p : myChannel.swaps) {
      println("[Debug] Attempting to create a PaletteUIElement for palette " + p);
      puie = new PaletteUIElement(myChannel, p, "" + i);
      puie.setGroup(myGroup);
      children.add(puie);
      i++;
    }
    
    //Sort them
    sortElements();
    
  }
  
  
  public void sortElements() {
    //TODO
    int x = LAYOUT_SIZE_GUTTER;
    for (PaletteUIElement child : children) {
      child.setPosition(x, LAYOUT_SIZE_GUTTER);
      x += child.getWidth();
      x += LAYOUT_SIZE_GUTTER; 
    }
  }
  
  public void dispose() {
    //TODO
  }
  
  public void setGroup (Group theGroup) {
    myGroup.setGroup(theGroup);
  }
  
  
  public void setSize(int w, int h) {
    myGroup.setSize(w, h);
    //sortElements();
  }
  
  public void setPosition(int x, int y) {
    myGroup.setPosition(x, y);
  }
  
  
}
