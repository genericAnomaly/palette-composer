class ImageControl extends Canvas {
  
  //Payload
  PImage content;
  PGraphics rendered;
  
  //State
  Boolean isRendering = false;
  
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
    content = createImage(w, h, ARGB);
//    content.loadPixels();
//    int dim = w*h;
    //for (int i=0; i<dim; i++) content.pixels[i] = color(i%256, 256-i%256, abs(i%512-256) );
    //for (int i=0; i<dim; i++) content.pixels[i] = color(abs((i/4)%512-256), abs((i+128)%512-256), abs(i%512-256) );
//    for (int i=0; i<dim; i++) content.pixels[i] = color( 191 + 64*(i%2), 0.5 );
//    content.updatePixels();
    renderContent();
    dropShadow = false;
  }
  
  
  public void draw(PApplet p) {
    p.pushMatrix();
    p.translate(x, y);
    //if (dropShadow) image(shadow, 0, 0);
    try {
      if (rendered != null && rendered.canDraw()) {
        p.image(rendered, 0, 0);
      }
    } catch (Exception e) {
      //I think this is mostly dealt with. Not necessarily ideally but it's not tripping anymore. Leaving this here for now.
      //e.printStackTrace();
      print("#");
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
    if (i == null) return;  //TODO: throw an exception maybe?
    content = i;
    renderContent();
  }
  
  public void addLayer(PImage layer) {
    //destructively layer a new image onto the current image.
    PGraphics composite = createGraphics(content.width, content.height);
    composite.beginDraw();
    composite.image(content, 0, 0);
    composite.image(layer, 0, 0);
    composite.endDraw();
    setImage(composite);
  }

  //Function to prepare copy content to rendered at a suitable size and position for display
  private void renderContent() {
    //Use isRendering to ensure renderContent never steps on its own toes. Should never actually be an issue.
    if (isRendering) return;
    isRendering = true;
    //Initialise the PGraphics object
    PGraphics render = createGraphics(w, h);
    //Work from a method variable to prevent issues with content being changed during execution by other threads
    PImage source = content;
    //Figure out what scale will fill the panel, respecting global gutters on ImageControl objects
    float scaleX = (render.width-LAYOUT_IMAGE_PADDING)/((float) source.width);
    float scaleY = (render.height-LAYOUT_IMAGE_PADDING)/((float) source.height);
    //For scales above 100%, use multiples of 100% only!
    if (scaleX>1) scaleX = floor(scaleX);
    if (scaleY>1) scaleY = floor(scaleY); 
    //Preserve aspect ratio by choosing the smallest scale possible
    float scaleBoth = scaleX;
    if (scaleY < scaleX) scaleBoth = scaleY;
    //Draw it to the PGraphics object
    render.beginDraw();
    //noSmooth is critical, otherwise scaling up causes interpolation, the WORST THING IN THE WORLD
    if (scaleBoth>1) render.noSmooth();
    //Draw it to the center (that's all that ugly as doubleheck math is for)
    render.image(content, (render.width-source.width*scaleBoth)/2, (render.height-source.height*scaleBoth)/2, source.width*scaleBoth, source.height*scaleBoth);
    //Finalise the graphic
    render.endDraw();
    rendered = render;
    isRendering = false;
  }



}
