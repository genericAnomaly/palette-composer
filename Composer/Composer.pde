// Need G4P library
import g4p_controls.*;
import java.awt.Color;
import java.util.ArrayList;

PImage baseSprite;
ArrayList<Channel> channels;
ArrayList<GPanel> channelPanels;

public void setup(){
  size(640, 480, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here
  
  
  
}

public void draw(){
  background(96);
  //if (baseSprite != null) sBase.setGraphic(baseSprite);
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}



public void onLoadSpriteSelected(File f) {
  //Abort if cancelled
  if (f == null) return;
  //Load the file
  baseSprite = loadImage(f.getAbsolutePath());
  imageToSketchpad(baseSprite, sBase);
}

public void onLoadJSONSelected(File f) {
  //Abort if cancelled
  if (f == null) return;
  //Load the file
  try {
    JSONObject json = loadJSONObject( f.getAbsolutePath() );
    loadJSON(json);
  } catch (Exception e) {
    //TODO: Change this to pop up a dialog box
    println("An error occured while attempting to load your channels! Check your JSON and try again. Exception report printed to stderr.");
    e.printStackTrace();
    return;
  }
}

public void imageToSketchpad(PImage sprite, GSketchPad pad) {
  PGraphics pg = createGraphics((int) pad.getWidth(), (int) pad.getHeight());
  //Figure out what scale will fill the panel
  float scaleX = pg.width/sprite.width;
  float scaleY = pg.height/sprite.height;
  //For scales above 100%, use multiples of 100% only!
  if (scaleX>1) scaleX = floor(scaleX);
  if (scaleY>1) scaleY = floor(scaleY); 
  //Preserve aspect ratio by choosing the smallest scale possible
  float scaleBoth = scaleX;
  if (scaleY < scaleX) scaleBoth = scaleY;
  //Draw it to the PGraphics object
  pg.beginDraw();
  //noSmooth is critical, otherwise scaling up causes interpolation, the WORST THING IN THE WORLD
  if (scaleBoth>1) pg.noSmooth();
  //Draw it to the center (that's all that ugly as doubleheck math is for)
  pg.image(sprite, (pg.width-sprite.width*scaleBoth)/2, (pg.height-sprite.height*scaleBoth)/2, sprite.width*scaleBoth, sprite.height*scaleBoth);
  pg.endDraw();
  //Send it to the sketchpad
  pad.setGraphic(pg);
}











public void loadJSON(JSONObject json) {
  //Get the channel names
  String[] channelNames = JSONHelper.getKeyArray(json);
  //Initialise and reserve space in the channels ArrayList
  channels = new ArrayList<Channel>(channelNames.length);
  
  for (String channel : channelNames) {
    JSONArray jarray;
    try {
      jarray = json.getJSONArray(channel);
    } catch (Exception e) {
      println("An error occured while attempting to load your channels! Check your JSON and try again. Exception report printed to stderr.");
      e.printStackTrace();
      return;
    }
    channels.add( new Channel(channel, jarray) );
  }
  
  //TODO: this loop's debug, pull it any time
  for (Channel c : channels) {
    println(c);
  }
  
  clearChannelPanels();
  channelPanels = new ArrayList<GPanel>( channels.size() );
  for (int i=0; i<channels.size(); i++) {
    GPanel panel = new GPanel(this, 0, 20+i*48, 640, 52, channels.get(i).name);
    panel.setDraggable(false);
    panel.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    panel.setOpaque(true);
    panel.addEventHandler(this, "onChannelPanelEvent");
    pChannels.addControl(panel);
    channelPanels.add(panel);
  }
  arrangeChannelPanels();
}

public void onChannelPanelEvent(GPanel source, GEvent event) {
  println("panelBase - GPanel >> GEvent." + event + " @ " + millis());
  println("source.getX() = " + source.getX() + ", source.getY() = " + source.getY());
  arrangeChannelPanels();
}

public void clearChannelPanels() {
  if (channelPanels == null) return;
  for (GPanel panel : channelPanels) panel.dispose();
  channelPanels = null;
}

public void arrangeChannelPanels() {
  println("Attempting to arrange ChannelPanels");
  int y = 20;
  for (GPanel panel : channelPanels) {
    println("Moving panel to y=" + y);
    panel.moveTo(0, y);
    if (panel.isCollapsed()) {
      y += 20;
    } else {
      y += panel.getHeight();
    }
  }
}




void fill(Color c) {
  fill( c.getRed(), c.getBlue(), c.getGreen() );
}




