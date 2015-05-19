public class Channel {
  
  String name;
  Palette base;
  ArrayList<Palette> swaps;
  
  public Channel (String n, JSONArray json) {
    //name
    name = n;
    
    //base
    String[] keys = JSONHelper.getKeyArray( json.getJSONObject(0) );
    base = new Palette(keys);
    
    //swaps
    swaps = new ArrayList<Palette>(keys.length);
    for (int i=0; i<json.size(); i++) {
      JSONObject paletteJSON = json.getJSONObject(i);
      String[] paletteStrings = new String[keys.length];
      for (int j=0; j<keys.length; j++) {
        paletteStrings[j] = paletteJSON.getString(keys[j]); 
      }
      swaps.add( new Palette(paletteStrings) );
    }
  }
  
  
  public String toString() {
    String s = "[Channel]\n";
    s += "name: " + name + "\n";
    s += "base: \n";
    s += base;
    s += "swaps: \n";
    for (Palette p : swaps) s += p;
    return s;
  }
  
}
