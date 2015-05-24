public class PaletteUIElement {
  
  Palette myPalette;
  Channel myChannel;
  
  Group myGroup;
  Toggle myToggle;
  ImageControl myImage;
  
  String name;
  
  public PaletteUIElement(Channel c, Palette p, String n) {
    myChannel = c;
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
  
  
  
}
