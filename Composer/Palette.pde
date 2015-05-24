public class Palette {
  
  Color[] colors;
  int[] colorInts;
  
  public Palette(int size) {
    colors = new Color[size];
    for (int i=0; i<size; i++) colors[i] = new Color( ((float)i )/size, ((float)i )/size, ((float)i )/size); 
  }
  
  public Palette(String[] strings) {
    loadStringArray(strings);
  }
  
  private void loadIntArray() {
    colorInts = new int[colors.length];
    for (int i=0; i < colors.length; i++) {
      colorInts[i] = awtColorToInt(colors[i]);
    }
  }
  
  public int getSize() {
    return colors.length;
  } 
  
  
  public PImage paletteSwap(PImage source, Palette base) {
    PImage target = createImage(source.width, source.height, RGB);
    target.loadPixels();
    source.loadPixels();
    
    //TODO: Consider just doing away with the current colors array and only storing ints since we can't really use awt Colors anyway
    loadIntArray();
    
    for (int i=0; i<source.pixels.length; i++) {
      for (int j=0; j<colorInts.length; j++) {
        if (source.pixels[i] == colorInts[j]) target.pixels[i] = source.pixels[i];
      }
    }
    
    target.updatePixels();
    return target;
    //NB: This returns a PIMmage of ONLY the altered pixels for layering, to avoid potential collisions 
  }
  
  
  public void loadStringArray(String[] strings) {
    colors = new Color[strings.length];
    for (int i=0; i<strings.length; i++) colors[i] = Color.decode("#"+strings[i]);
  }
  
  public String[] toStringArray() {
    //TODO
    return new String[]{"TODO"};
  }
  
  
  
  public void drawPalette(float x, float y) {
    drawPalette(x, y, 0, 8);
    //TODO: private instance variables defining how this palette should draw?
  }
  
  public void drawPalette(float x, float y, float tX, float tY) {
    pushMatrix();
    translate(x, y);
    for (Color c : colors) {
      fill(c);
      rect(0, 0, 8, 8);
      translate(tX, tY);
    }
    popMatrix();
  }
  
  public String toString() {
    return toString("  ");
  }
  
  public String toString(String i) {
    i += "  ";
    String s = i+ "[Palette]\n";
    s += i + "Size: " + colors.length + "\n";
    for (Color c : colors) s += i + " - " + c + "\n";
    return s;
  }
  
  public PImage toPImage () {
    return toPImage(1, colors.length);
  }
  
  public PImage toPImage (int rows, int columns) {
    PImage p = createImage(columns, rows, RGB);
    //fill columns first
    int x = 0;
    int y = 0;
    p.loadPixels();
    for (int i=0; (i<colors.length && i<p.pixels.length); i++) {
      //p.pixels[i] = awtColorToInt(colors[i]);
      p.pixels[x+columns*y] = awtColorToInt(colors[i]);
      y++;
      if (y >= rows) {
        x++;
        y = 0;
      }
    }
    p.updatePixels();
    return p;
  }
  
}



