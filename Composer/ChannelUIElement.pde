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
    PaletteUIElement puie = new PaletteUIElement(this, myChannel.base, "base");
    puie.setGroup(myGroup);
    children.add(puie);
    
    //Quickly calculate our target height based on 
    myGroup.setBackgroundHeight(puie.myHeight + LAYOUT_PALETTE_PADDING*2);
    
    int i=0;
    for (Palette p : myChannel.swaps) {
      puie = new PaletteUIElement(this, p, "" + i);
      puie.setGroup(myGroup);
      children.add(puie);
      i++;
    }
    
    //Sort them
    sortElements();
    
  }
  
  public void highlightElement(PaletteUIElement p) {
    for (PaletteUIElement puie : children) {
      //puie.myButton.listen(false);
      //puie.myButton.setInternalValue(0);
      //puie.myButton.listen(true);
      //TODO: UUUUUGH this is SO IRRITATING I guess I'll probably just switch to buttons and like, change their colors when they become active or whatevs.
    }
  //  p.myButton.setValue(true);
    //TODO: fix all this direct access of foreigh class members in the *UIElement classes. I wrote this way the heck too late at night.
    //TODO: While we're at it, fix up the spaghetti code handling clicking a PaletteUIElement to be more OO consistent and less horrible.
  }
  
  public void sortElements() {
    //TODO
    int x = LAYOUT_PALETTE_PADDING;
    for (PaletteUIElement child : children) {
      child.setPosition(x, LAYOUT_PALETTE_PADDING);
      x += child.getWidth();
      x += LAYOUT_PALETTE_PADDING; 
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
  
  public void setWidth(int w) {
    myGroup.setWidth(w);
  }
  
  public void setPosition(int x, int y) {
    myGroup.setPosition(x, y);
  }
  
  
}
