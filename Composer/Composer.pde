import java.awt.event.*;
import java.awt.Dimension;
import java.awt.Color;

import javax.swing.JRootPane;
import javax.swing.JFrame;

import java.util.ArrayList;

import controlP5.*;


//UI Constants
int LAYOUT_SIZE_GUTTER = 6;
int LAYOUT_SIZE_TOOLBAR = 20;
int LAYOUT_MINIMUM_WIDTH = 640;
int LAYOUT_MINIMUM_HEIGHT = 480;

int LAYOUT_CHANNEL_MINIMUM_HEIGHT = 32;
int LAYOUT_IMAGE_GUTTER = 8;

int LAYOUT_PALETTE_MAX_ROWS = 4;
int LAYOUT_PALETTE_SQUARE_SIZE = 8;

//UI COLORS
int LAYOUT_COLOR_BG = 80;
int LAYOUT_COLOR_PANELS = 96;
int LAYOUT_COLOR_TOOLBAR = 127;
int LAYOUT_COLOR_CHANNELS = 108;

//ControlP5 UI Elements
ControlP5 cp5;

Group gToolbar;
Group gBase;
Group gPreview;
Group gMixer;
Group gChannels;

ImageControl iBase;
ImageControl iPreview;

Button bSave;
Button bLoadImage;
Button bLoadJSON;

ChannelManagerUIElement uiChannelManager;

ArrayList<Group> gChannelList;


//Vars
PImage baseSprite;
ArrayList<Channel> channels;
PImage testPI;
Boolean testLoad = false;

public void setup(){
  //Size the frame
  size(640, 480);
  
  //Initialise ArrayLists empty to avoid having to check for null all the time
  gChannelList = new ArrayList<Group>();
  
  //Build the UI
  buildUIElements();
  
  //Set up frame junk if we have one
  if (frame != null) {
    frame.setTitle("Palette Composer");
    frame.setResizable(true);
    frame.setMinimumSize(new Dimension(LAYOUT_MINIMUM_WIDTH, LAYOUT_MINIMUM_HEIGHT));
    frame.addComponentListener(new FrameListener());
    
    JRootPane pane = ( (JFrame) frame).getRootPane();
    sortUIElements( pane.getWidth(), pane.getHeight() );
  }
  
}


void draw() {
  background(LAYOUT_COLOR_BG);
  
  
//  if (testPI != null) {
//    PImage pi = testPI;
//    image(pi, 320, 460, 40, 40);
//  }
  
  if (testLoad) testLoadJSON();
}



public void buildUIElements () {
  //Create CP5
  cp5 = new ControlP5(this);
  cp5.enableShortcuts();
  
  //Toolbar  ===================================================
  gToolbar = cp5.addGroup("Toolbar");
  gToolbar.hideBar();
  gToolbar.disableCollapse();
  gToolbar.setMoveable(false);
  gToolbar.setBackgroundColor(LAYOUT_COLOR_TOOLBAR);
  
  bLoadImage = cp5.addButton("Load Sprite");
  bLoadImage.setPosition(8, 0);
  bLoadImage.setGroup(gToolbar);
  
  bLoadJSON = cp5.addButton("Load JSON");
  bLoadJSON.setPosition(88, 0);
  bLoadJSON.setGroup(gToolbar);
  
  bSave = cp5.addButton("Save JSON");
  //   .setImages(imgs)
  //   .updateSize()
  bSave.setPosition(168, 0);
  bSave.setGroup(gToolbar);
    
  
  //Base Sprite Panel  =========================================
  gBase = cp5.addGroup("Base Sprite");
  gBase.setBackgroundColor(LAYOUT_COLOR_PANELS);
  gBase.disableCollapse();
  gBase.setMoveable(false);
  
  //Base Sprite Image Control
  iBase = new ImageControl();
//  iBase.enableShadow(true);
  gBase.addCanvas(iBase);

  
  //Preview Sprite Panel  ======================================
  gPreview = cp5.addGroup("Preview Sprite");
  gPreview.setBackgroundColor(LAYOUT_COLOR_PANELS);
  gPreview.disableCollapse();
  gPreview.setMoveable(false);
  
  //Preview Sprite Image Control
  iPreview = new ImageControl();
  gPreview.addCanvas(iPreview);
  
  
  //Mixer Panel   ==============================================
  gMixer = cp5.addGroup("Palette Mixer");
  gMixer.setBackgroundColor(LAYOUT_COLOR_PANELS);
  gMixer.disableCollapse();
  gMixer.setMoveable(false);
  
  
  //Channel Manager Panel  =====================================
//  gChannels = cp5.addGroup("Channel Manager");
//  gChannels.setBackgroundColor(LAYOUT_COLOR_PANELS);
//  gChannels.disableCollapse();
//  gChannels.setMoveable(false);
  uiChannelManager = new ChannelManagerUIElement();
  
  sortUIElements(width, height);
}




public void sortUIElements(int paneWidth, int paneHeight) {
  //Calculate common size values
  float panelThird = (paneWidth - 4*LAYOUT_SIZE_GUTTER)/10;
  int panelSide = floor(3*panelThird);
  int panelTop = LAYOUT_SIZE_GUTTER + LAYOUT_SIZE_TOOLBAR + gBase.getBarHeight();
  int channelManTop = panelTop + panelSide + LAYOUT_SIZE_GUTTER + gBase.getBarHeight();  //don't bother delving, just assume everyone's got the same bar height
  
  //Toolbar
  gToolbar.setPosition(0, 0);
  gToolbar.setSize(paneWidth, LAYOUT_SIZE_TOOLBAR );
  
  //Base Sprite Panel
  gBase.setPosition(LAYOUT_SIZE_GUTTER, panelTop );
  gBase.setSize(panelSide, panelSide);
  iBase.setSize(panelSide, panelSide);
  
  //Preview Sprite Panel
  gPreview.setPosition(LAYOUT_SIZE_GUTTER*2 + panelSide, panelTop);
  gPreview.setSize(panelSide, panelSide);
  iPreview.setSize(panelSide, panelSide);
  
  //Mixer Panel
  gMixer.setPosition(LAYOUT_SIZE_GUTTER*3 + 2*panelSide, panelTop);
  gMixer.setSize( paneWidth - (2*panelSide+4*LAYOUT_SIZE_GUTTER), panelSide);
  
  //Channel Manager UI Element
  uiChannelManager.setPosition(LAYOUT_SIZE_GUTTER, channelManTop);
  uiChannelManager.setSize(paneWidth - LAYOUT_SIZE_GUTTER*2, panelSide);
  
}






public void controlEvent(ControlEvent theEvent) {
  //println(theEvent.getController());
  if (theEvent.isGroup()) {
    if ( uiChannelManager.children != null ) {
      for (ChannelUIElement cuie : uiChannelManager.children) {
        if (cuie.myGroup == theEvent.getGroup()) uiChannelManager.sortElements();
      }
    }
  }
  if (theEvent.isController()){
    if (theEvent.getController() == bLoadImage) selectInput("Select sprite to load", "onLoadSpriteSelected"); 
    if (theEvent.getController() == bLoadJSON) selectInput("Select palette file to load", "onLoadJSONSelected");
    if (theEvent.getController() == bSave) testLoad = true;
    
    if (theEvent.getController() instanceof Toggle) {
      println("Toggle fired");
      Toggle t = (Toggle) theEvent.getController();
      PaletteUIElement source = uiChannelManager.getPaletteUIElement(t);
      println("Source: " + source.myPalette);
      source.parent.highlightElement(source);
      PImage change = source.paletteSwap(baseSprite);
      
      //this is all mega sloppy and will be tidied up shortly.
      PGraphics swapped = createGraphics(baseSprite.width, baseSprite.height);
      swapped.beginDraw();
      swapped.image(baseSprite, 0, 0);
      swapped.image(change, 0, 0);
      swapped.endDraw();
      iPreview.setImage(swapped);
      
    }
    
  }
}

public void onLoadSpriteSelected(File f) {
  //Abort if cancelled
  if (f == null) return;
  //Load the file
  try {
    baseSprite = loadImage(f.getAbsolutePath());
  } catch (Exception e) {
    //TODO: Error message in a modal dialog box
    println("[ERROR] Exception occurred while attempting to load your image. Please make sure your file is valid and try again.");
    return;
  }
  if (baseSprite != null) {
    iBase.setImage(baseSprite);
    iPreview.setImage(baseSprite);
  }
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
    println("[ERROR] Exception occured while attempting to load your channels! Please make sure your file is valid and try again.");
    loop();
    //e.printStackTrace();
    return;
  }
}


public void loadJSON(JSONObject json) {
  //Get the channel names
  String[] channelNames = JSONHelper.getKeyArray(json);
  //Initialise and reserve space in the channels ArrayList
  channels = new ArrayList<Channel>(channelNames.length);
  
  for (String channel : channelNames) {
    JSONArray jarray;
    jarray = json.getJSONArray(channel); //TODO: put this back in the trycatch and add loop() to the catcher.
    try {
      //jarray = json.getJSONArray(channel);
    } catch (Exception e) {
      println("[ERROR] Exception occured while attempting to parse your channels! Please make sure your file is valid and try again.");
      e.printStackTrace();
      return;
    }
    channels.add( new Channel(channel, jarray) );
  }
  
  //TODO: this loop's debug, pull it any time
  for (Channel c : channels) {
    //println(c);
  }
  
  //TODO: Panels for each channel
  //buildChannelPanels();
  noLoop();
  uiChannelManager.loadChannels(channels);
  loop();
}



public void disposeChannelPanels () {
  if (gChannelList != null) {
    //TODO: Make sure this is properly disposing of the UI elements within gChannelList
    for (Group channelPanel : gChannelList) channelPanel.remove();
  }
  gChannelList = new ArrayList<Group>();
}

public void buildChannelPanels () {
  //Turn off the draw loop during modifications to the UI to try to squelch that ConcurrentModificationException
  noLoop();
  
  //TODO
  disposeChannelPanels();
  gChannelList = new ArrayList<Group>(channels.size());
  
  
  for (Channel c : channels) {
    ChannelUIElement cuie = new ChannelUIElement(c);
    cuie.setGroup(gChannels);
  }
  
  /*
  for (Channel c : channels) {
    println("Loading channel " + c.name);
    Group channelPanel = cp5.addGroup(c.name);
    //channelPanel.disableCollapse();
    channelPanel.setMoveable(false);
    channelPanel.setBackgroundColor(LAYOUT_COLOR_CHANNELS);
    channelPanel.activateEvent(true);
    channelPanel.setGroup(gChannels);
    gChannelList.add(channelPanel);
    
    //Now add Palettes
    PaletteUIElement puie = new PaletteUIElement(c, c.base, "base");
    puie.setGroup(channelPanel);

  }
  */
  
  sortUIElements(width, height);
  
  try{ 
    Thread.sleep(200);
  } catch (Exception e) {
    
  }
  
  loop();
}


void testLoadJSON() {
  JSONObject json = loadJSONObject( "../../testfiles/kirhos.json" );
  //for (int i=0; i<50; i++) {
    //println("Test " + i);
    loadJSON(json);
  //  redraw();
  //}
  
}

void fill(Color c) {
  fill( c.getRed(), c.getBlue(), c.getGreen() );
}

int awtColorToInt(Color c) {
  return color (c.getRed(), c.getBlue(), c.getGreen());
}



