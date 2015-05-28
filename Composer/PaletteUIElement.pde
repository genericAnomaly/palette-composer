public class PaletteUIElement {
  
  Palette myPalette;
  Channel myChannel;
  
  ChannelUIElement parent;
  Group myGroup;
  //Toggle myToggle;
  Button myButton;
  ImageControl myImage;
  
  int myWidth;
  int myHeight;
  String name;
  
  public PaletteUIElement(ChannelUIElement c, Palette p, String n) {
    parent = c;
    myChannel = c.myChannel;
    myPalette = p;
    name = n;
    buildElement();
  }
  
  
  private void buildElement (){
    int rows = myPalette.getSize();
    if (rows > LAYOUT_PALETTE_MAX_ROWS) rows = LAYOUT_PALETTE_MAX_ROWS;
    int cols = ceil( (float) myPalette.getSize()/rows);
    
    myWidth = cols*LAYOUT_PALETTE_SQUARE_SIZE + 2*LAYOUT_IMAGE_PADDING;
    myHeight = rows*LAYOUT_PALETTE_SQUARE_SIZE + 2*LAYOUT_IMAGE_PADDING;
    if (myWidth < myHeight) myWidth = myHeight;
    
    myGroup = cp5.addGroup(myChannel.name + "_" + name);
    //myGroup.setPosition(LAYOUT_PANEL_GUTTER, LAYOUT_PANEL_GUTTER);
    myGroup.setSize(myWidth, myHeight);
    myGroup.setMoveable(false);
    myGroup.disableCollapse();
    myGroup.hideBar();
    
    
    myButton = cp5.addButton(myChannel.name + "_" + name + "_button");
    myButton.setSize(myWidth, myHeight);
    myButton.setPosition(0, 0);
    myButton.setLabel("");
    myButton.setGroup(myGroup);
    
    myImage = new ImageControl();
    myGroup.addCanvas(myImage);
    myImage.post();
    myImage.setSize( myWidth, myHeight);
    myImage.setImage(myPalette.toPImage(rows, cols));

    
  }
  
  public void setGroup (Group theGroup) {
    myGroup.setGroup(theGroup);
  }
  
  public int getWidth() {
    return myGroup.getWidth();
  }
  
  public void setPosition(int x, int y) {
    myGroup.setPosition(x, y);
  }
  
  
  public PImage paletteSwap(PImage source) {
    return myPalette.paletteSwap(source, parent.myChannel.base);
  }
  
  
}
