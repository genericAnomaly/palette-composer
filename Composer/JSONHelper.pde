import java.util.Set;

public static class JSONHelper {

  //Some static JSON helper methods that aren't included in Processing's default JSONObject

  public static String[] getKeyArray(JSONObject json) {
    Set keys = json.keys();
    String[] array = new String[1];
    array = (String[]) keys.toArray(array);
    return array;
  }
  
  
  
}
