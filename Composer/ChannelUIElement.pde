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
    myGroup.setGroup(gChannels);
    //gChannelList.add(channelPanel);
    
    //TODO: Build optional scrollbar
    
    //Build the PaletteUIElements
    PaletteUIElement puie = new PaletteUIElement(myChannel, myChannel.base, "base");
    puie.setGroup(myGroup);
    
    for (Palette p : myChannel.swaps) {
//      PaletteUIElement puie = new PaletteUIElement(myChannel, p, );
//      puie.setGroup(myGroup);
    }
    
  }
  
  
  public void sortElements() {
    //TODO
  }
  
  public void dispose() {
    //TODO
  }
  
  public void setGroup (Group theGroup) {
    myGroup.setGroup(theGroup);
  }
  
  
}
