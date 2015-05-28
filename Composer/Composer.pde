import java.awt.event.*;
import java.awt.Dimension;
import java.awt.Color;

import javax.swing.JRootPane;
import javax.swing.JFrame;

import java.util.ArrayList;

import controlP5.*;


//UI size constants
final int LAYOUT_PANEL_GUTTER = 3;
final int LAYOUT_IMAGE_PADDING = 8;
final int LAYOUT_PALETTE_PADDING = 6;
final int LAYOUT_CHANNEL_MINIMUM_HEIGHT = 32;
final int LAYOUT_TOOLBAR_HEIGHT = 20;
final int LAYOUT_FRAME_MINIMUM_WIDTH = 640;
final int LAYOUT_FRAME_MINIMUM_HEIGHT = 480;


final int LAYOUT_PALETTE_MAX_ROWS = 4;
final int LAYOUT_PALETTE_SQUARE_SIZE = 8;

//UI color constants
final int LAYOUT_COLOR_BG = #333333;
final int LAYOUT_COLOR_PANELS = #666666;
final int LAYOUT_COLOR_TOOLBAR = #888888;
final int LAYOUT_COLOR_CHANNELS = #777777;
//TODO: buttons and palettes
final int LAYOUT_COLOR_DEFAULT_NEUTRAL = #444444;
final int LAYOUT_COLOR_DEFAULT_HOVER = #ffcc00;
final int LAYOUT_COLOR_DEFAULT_CLICK = #cc9900;
final int LAYOUT_COLOR_DEFAULT_LABEL_CAPTION = #ffffff;
final int LAYOUT_COLOR_DEFAULT_LABEL_VALUE = #ffffff;
final int LAYOUT_COLOR_PALETTE_NEUTRAL = 0x00000000;
final int LAYOUT_COLOR_PALETTE_HOVER = #ffffff;
final int LAYOUT_COLOR_PALLETE_CLICK = #ffcc00;
final int LAYOUT_COLOR_PALLETE_SELECTED = #ffcc00;
  //bCol = new CColor( #ff0000, #00ff00, #0000ff, #FFFF00, #00FFFF);
  //Hover, Default, Onclick, LabelOver, LabelOffset


//ControlP5 UI Elements
ControlP5 cp5;

CColor cDefault;
CColor cPalette;

Group gToolbar;
Group gBase;
Group gPreview;
Group gMixer;
Group gChannels;

ImageControl iBase;
ImageControl iPreview;

Button bLoadImage;
Button bLoadJSON;
Button bSave;

ChannelManagerUIElement uiChannelManager;


//Working data
PImage baseSprite;
ArrayList<Channel> channels;


public void setup(){
  //Size the frame
  size(LAYOUT_FRAME_MINIMUM_WIDTH, LAYOUT_FRAME_MINIMUM_HEIGHT);
  
  //Build the UI
  buildUIElements();
  
  //Set up frame junk if we have one
  if (frame != null) {
    frame.setTitle("Palette Composer");
    frame.setResizable(true);
    frame.setMinimumSize(new Dimension(LAYOUT_FRAME_MINIMUM_WIDTH, LAYOUT_FRAME_MINIMUM_HEIGHT));
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
  
  //Create colors
  cDefault = new CColor(LAYOUT_COLOR_DEFAULT_HOVER, LAYOUT_COLOR_DEFAULT_NEUTRAL, LAYOUT_COLOR_DEFAULT_CLICK, LAYOUT_COLOR_DEFAULT_LABEL_CAPTION, LAYOUT_COLOR_DEFAULT_LABEL_VALUE);
  cp5.setColor(cDefault);

 
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
  uiChannelManager = new ChannelManagerUIElement();
  
  sortUIElements(width, height);
}




public void sortUIElements(int paneWidth, int paneHeight) {
  //Calculate common size values
  float panelThird = (paneWidth - 4*LAYOUT_PANEL_GUTTER)/10;
  int panelSide = floor(3*panelThird);
  int panelTop = LAYOUT_PANEL_GUTTER + LAYOUT_TOOLBAR_HEIGHT + gBase.getBarHeight();
  int channelManTop = panelTop + panelSide + LAYOUT_PANEL_GUTTER + gBase.getBarHeight();  //don't bother delving, just assume everyone's got the same bar height
  
  //Toolbar
  gToolbar.setPosition(0, 0);
  gToolbar.setSize(paneWidth, LAYOUT_TOOLBAR_HEIGHT );
  
  //Base Sprite Panel
  gBase.setPosition(LAYOUT_PANEL_GUTTER, panelTop );
  gBase.setSize(panelSide, panelSide);
  iBase.setSize(panelSide, panelSide);
  
  //Preview Sprite Panel
  gPreview.setPosition(LAYOUT_PANEL_GUTTER*2 + panelSide, panelTop);
  gPreview.setSize(panelSide, panelSide);
  iPreview.setSize(panelSide, panelSide);
  
  //Mixer Panel
  gMixer.setPosition(LAYOUT_PANEL_GUTTER*3 + 2*panelSide, panelTop);
  gMixer.setSize( paneWidth - (2*panelSide+4*LAYOUT_PANEL_GUTTER), panelSide);
  
  //Channel Manager UI Element
  uiChannelManager.setPosition(LAYOUT_PANEL_GUTTER, channelManTop);
  uiChannelManager.setSize(paneWidth - LAYOUT_PANEL_GUTTER*2, paneHeight - channelManTop - LAYOUT_PANEL_GUTTER);
  
}






public void controlEvent(ControlEvent theEvent) {
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
    
    
    //TODO: Move all this stuff into a custom handler inside ChannelManagerUIElement
    if (theEvent.getController() instanceof Button) {
      println("Button fired");
      Button b = (Button) theEvent.getController();
      PaletteUIElement source = uiChannelManager.getPaletteUIElement(b);
      if (source == null) {
        return;
      }
      println("Source: " + source.myPalette);
      source.parent.highlightElement(source);
      if (baseSprite == null) return;
      PImage change = source.paletteSwap(baseSprite);
      iPreview.addLayer(change);
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
  //Try to read them in
  for (String channel : channelNames) {
    JSONArray jarray;
    try {
      jarray = json.getJSONArray(channel);
    } catch (Exception e) {
      println("[ERROR] Exception occured while attempting to parse your channels! Please make sure your file is valid and try again.");
      //This error will occur if you have non-array values in channel keys
      //e.printStackTrace();
      return;
    }
    channels.add( new Channel(channel, jarray) );
  }
  //Pass the channels we loaded to the ChannelManagerUIElement
  uiChannelManager.loadChannels(channels);
}


/*
public void disposeChannelPanels () {
  if (gChannelList != null) {
    //TODO: Make sure this is properly disposing of the UI elements within gChannelList
    for (Group channelPanel : gChannelList) channelPanel.remove();
  }
  gChannelList = new ArrayList<Group>();
}
*/


void testLoadJSON() {
  JSONObject json = loadJSONObject( "../../testfiles/kirhos.json" );
  //for (int i=0; i<50; i++) {
    //println("Test " + i);
    loadJSON(json);
  //  redraw();
  //}
  
}

void fill(Color c) {
  fill( c.getRed(), c.getGreen(), c.getBlue() );
}

int awtColorToInt(Color c) {
  return color (c.getRed(), c.getGreen(), c.getBlue());
}



