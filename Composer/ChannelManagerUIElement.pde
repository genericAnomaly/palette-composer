public class ChannelManagerUIElement {
  
  ArrayList<ChannelUIElement> children;
  
  Group myGroup;
  
  public ChannelManagerUIElement() {
    buildElement();
  }
  
  public void loadChannels(ArrayList<Channel> channels) {
    
  }
  
  private void buildElement() {
    myGroup = cp5.addGroup("Channel Manager");
    myGroup.setBackgroundColor(LAYOUT_COLOR_PANELS);
    myGroup.disableCollapse();
    myGroup.setMoveable(false);
  }
  
  public void sortElements() {
    //TODO
  }
  
}
