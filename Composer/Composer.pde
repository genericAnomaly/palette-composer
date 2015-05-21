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

int LAYOUT_IMAGE_GUTTER = 8;

int LAYOUT_COLOR_BG = 80;
int LAYOUT_COLOR_PANELS = 96;
int LAYOUT_COLOR_TOOLBAR = 127;


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


//Vars
PImage baseSprite;
ArrayList<Channel> channels;

public void setup(){
  //Size the frame
  size(640, 480);
  
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
  //iBase.setImage(loadImage("kirhos.png"));
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
  gChannels = cp5.addGroup("Channel Manager");
  gChannels.setBackgroundColor(LAYOUT_COLOR_PANELS);
  gChannels.disableCollapse();
  gChannels.setMoveable(false);
  
  
  sortUIElements(width, height);
}




public void sortUIElements(int paneWidth, int paneHeight) {
  //Calculate common size values
  float panelThird = (paneWidth - 4*LAYOUT_SIZE_GUTTER)/10;
  int panelSide = floor(3*panelThird);
  int panelTop = LAYOUT_SIZE_GUTTER + LAYOUT_SIZE_TOOLBAR + gBase.getBarHeight();
  int channelManTop = panelTop + panelSide + LAYOUT_SIZE_GUTTER + gChannels.getBarHeight();
  
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
  gMixer.setSize( floor(4*panelThird), panelSide);
  
  //Channel Manager Panel
  gChannels.setPosition(LAYOUT_SIZE_GUTTER, channelManTop);
  gChannels.setSize(LAYOUT_SIZE_GUTTER*2 + 2*panelSide + floor(4*panelThird), 160); //force alignment with Mixer panel
  
}







public void controlEvent(ControlEvent theEvent) {
  //println(theEvent.getController());
  if (theEvent.getController() == bLoadImage) selectInput("Select sprite to load", "onLoadSpriteSelected"); 
  if (theEvent.getController() == bLoadJSON)selectInput("Select palette file to load", "onLoadJSONSelected");
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
  iBase.setImage(baseSprite);
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
  
  /*
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
  */
  
}



void fill(Color c) {
  fill( c.getRed(), c.getBlue(), c.getGreen() );
}




