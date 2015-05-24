public class PaletteUIElement {
  
  Palette myPalette;
  Channel myChannel;
  
  Group myGroup;
  
  
  
  
  public PaletteUIElement(Channel c, Palette p) {
    myChannel = c;
    myPalette = p;
    buildElement();
  }
  
  
  private void buildElement (){
    int rows = myPalette.getSize();
    if (rows > LAYOUT_PALETTE_MAX_ROWS) rows = LAYOUT_PALETTE_MAX_ROWS;
    int cols = ceil( (float) myPalette.getSize()/rows);
    
    int myWidth = cols*LAYOUT_PALETTE_SQUARE_SIZE + 2*LAYOUT_IMAGE_GUTTER;
    int myHeight = rows*LAYOUT_PALETTE_SQUARE_SIZE + 2*LAYOUT_IMAGE_GUTTER;
    if (myWidth < myHeight) myWidth = myHeight;
    
    myGroup = cp5.addGroup(myChannel.name + "_" + "base");
    myGroup.setPosition(LAYOUT_SIZE_GUTTER, LAYOUT_SIZE_GUTTER);
    myGroup.setMoveable(false);
    myGroup.disableCollapse();
    myGroup.hideBar();
    
    
    Toggle t = cp5.addToggle(myChannel.name + "_" + "base" + "toggle");
    t.setSize(myWidth, myHeight);
    t.setPosition(0, 0);
    t.setLabel("");
    t.setGroup(myGroup);
    
    ImageControl i = new ImageControl();
    myGroup.addCanvas(i);
    i.post();
    i.setSize( myWidth, myHeight);
    i.setImage(myPalette.toPImage(rows, cols));

    
  }
  
  public void setGroup (Group theGroup) {
    myGroup.setGroup(theGroup);
  }
  
  
  
}
