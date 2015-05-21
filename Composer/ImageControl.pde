class ImageControl extends Canvas {
  
  //Payload
  PImage content;
  PGraphics rendered;
  
  //Location
  float x;
  float y;
  int w;
  int h;
  
  //Extras
  Boolean dropShadow;
  PGraphics shadow;
  
  public ImageControl() {
    init();
  }
  
  public void setup (PApplet theApplet) {
    init();  //init in both places in case CP5 decides to try to do something too early
  }
  
  private void init () {
    x = 0;
    y = 0;
    w = 32;
    h = 32;
    content = createImage(w, h, RGB);
    content.loadPixels();
    int dim = w*h;
    for (int i=0; i<dim; i++) content.pixels[i] = color(i%256, 256-i%256, abs(i%512-256) );
    content.updatePixels();
    renderContent();
    dropShadow = false;
  }
  
  
  public void draw(PApplet p) {
    p.pushMatrix();
    p.translate(x, y);
    //if (dropShadow) image(shadow, 0, 0);
    try {
      if (rendered != null) {
        p.image(rendered, 0, 0);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    p.popMatrix();
  }
  
  public void enableShadow(Boolean s) {
    //dropShadow = s;
  }
  
  public void setPosition(float px, float py) {
    x = px;
    y = py;
  }
  public void setSize(int pw, int ph) {
    if (w < 1) w = 1;
    if (h < 1) h = 1;
    w = pw;
    h = ph;
    if (content != null) renderContent();
  }
  public void setImage(PImage i) {
    content = i;
    renderContent();
  }

  //Function to prepare copy content to rendered at a suitable size and position for display
  private void renderContent() {
    //Initialise the PGraphics object
    rendered = createGraphics(w, h);
    //Figure out what scale will fill the panel, respecting global gutters on ImageControl objects
    float scaleX = (rendered.width-LAYOUT_IMAGE_GUTTER)/((float) content.width);
    float scaleY = (rendered.height-LAYOUT_IMAGE_GUTTER)/((float) content.height);
    //For scales above 100%, use multiples of 100% only!
    if (scaleX>1) scaleX = floor(scaleX);
    if (scaleY>1) scaleY = floor(scaleY); 
    //Preserve aspect ratio by choosing the smallest scale possible
    float scaleBoth = scaleX;
    if (scaleY < scaleX) scaleBoth = scaleY;
    //Draw it to the PGraphics object
    rendered.beginDraw();
    //noSmooth is critical, otherwise scaling up causes interpolation, the WORST THING IN THE WORLD
    if (scaleBoth>1) rendered.noSmooth();
    //Draw it to the center (that's all that ugly as doubleheck math is for)
    rendered.image(content, (rendered.width-content.width*scaleBoth)/2, (rendered.height-content.height*scaleBoth)/2, content.width*scaleBoth, content.height*scaleBoth);
    //Finalise the graphic
    rendered.endDraw();
  }



}
