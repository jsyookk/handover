class ConvertUrlPath{

  static String convertUrl(String orignalUrl , String gameUid){

       String newUrl = orignalUrl.replaceFirstMapped(
           RegExp('.png'), (match) => '_$gameUid${match.group(0)}');

      return newUrl;
  }

  static String getLastgameId(String gameUid){

    String id = gameUid.substring(gameUid.lastIndexOf('_')+1);

    return id;
  }

}