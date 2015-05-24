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
    int cols = ceil(myPalette.getSize()/rows);
    
    
    myGroup = cp5.addGroup(myChannel.name + "_" + "base");
    myGroup.setPosition(LAYOUT_SIZE_GUTTER, LAYOUT_SIZE_GUTTER);
    myGroup.setMoveable(false);
    myGroup.disableCollapse();
    myGroup.hideBar();
    
    
    Toggle t = cp5.addToggle(myChannel.name + "_" + "base" + "toggle");
    t.setSize(64, 64);
    t.setPosition(0, 0);
    t.setLabel("");
    t.setGroup(myGroup);
    
    ImageControl i = new ImageControl();
    myGroup.addCanvas(i);
    i.setSize(32, 32);
    i.post();
    i.setSize( cols*LAYOUT_PALETTE_SQUARE_SIZE+2*LAYOUT_IMAGE_GUTTER, rows*LAYOUT_PALETTE_SQUARE_SIZE+2*LAYOUT_IMAGE_GUTTER);
    //i.setImage(myPalette.toPImage(rows, cols));
 //   PImage pi = myPalette.toPImage(rows, cols);
    //image(pi, 320, 320);
    //i.setImage(pi);
 //   testPI = pi;
    //noLoop();
    
  }
  
  public void setGroup (Group theGroup) {
    myGroup.setGroup(theGroup);
  }
  
  
  
}
