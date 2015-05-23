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
    //for (int i=0; i<dim; i++) content.pixels[i] = color(i%256, 256-i%256, abs(i%512-256) );
    //for (int i=0; i<dim; i++) content.pixels[i] = color(abs((i/4)%512-256), abs((i+128)%512-256), abs(i%512-256) );
    for (int i=0; i<dim; i++) content.pixels[i] = color( 191 + 64*(i%2), 0.5 );
    content.updatePixels();
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
      //TODO: This damn thing keeps firing off pervasively during normal use.
      //It can be recreated by passing setImage a null value
      //e.printStackTrace();
      print("#"); //easier than a frickin' 30 line stack trace every frame
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

  //Function to prepare copy content to rendered at a suitable size and position for display
  private void renderContent() {
    //Initialise the PGraphics object
    PGraphics render = createGraphics(w, h);
    //Figure out what scale will fill the panel, respecting global gutters on ImageControl objects
    float scaleX = (render.width-LAYOUT_IMAGE_GUTTER)/((float) content.width);
    float scaleY = (render.height-LAYOUT_IMAGE_GUTTER)/((float) content.height);
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
    render.image(content, (render.width-content.width*scaleBoth)/2, (render.height-content.height*scaleBoth)/2, content.width*scaleBoth, content.height*scaleBoth);
    //Finalise the graphic
    render.endDraw();
    rendered = render;
  }



}
