public class PaletteUIElement {
  
  Palette myPalette;
  Channel myChannel;
  
  ChannelUIElement parent;
  Group myGroup;
  Toggle myToggle;
  ImageControl myImage;
  
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
    
    int myWidth = cols*LAYOUT_PALETTE_SQUARE_SIZE + 2*LAYOUT_IMAGE_GUTTER;
    int myHeight = rows*LAYOUT_PALETTE_SQUARE_SIZE + 2*LAYOUT_IMAGE_GUTTER;
    if (myWidth < myHeight) myWidth = myHeight;
    
    myGroup = cp5.addGroup(myChannel.name + "_" + name);
    myGroup.setPosition(LAYOUT_SIZE_GUTTER, LAYOUT_SIZE_GUTTER);
    myGroup.setSize(myWidth, myHeight);
    myGroup.setMoveable(false);
    myGroup.disableCollapse();
    myGroup.hideBar();
    
    
    myToggle = cp5.addToggle(myChannel.name + "_" + name + "_toggle");
    myToggle.setSize(myWidth, myHeight);
    myToggle.setPosition(0, 0);
    myToggle.setLabel("");
    myToggle.setGroup(myGroup);
    
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
