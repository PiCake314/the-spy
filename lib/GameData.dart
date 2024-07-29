class GameSaveData {
  String title;
  List<String> topic_list;

  GameSaveData({this.title = "", this.topic_list = const []});
}


class GameInfo{
  String spy;
  List<String> players;

  String topic;
  List<String> topic_list;

  GameInfo({this.spy = "", this.players = const [], this.topic = "", this.topic_list = const []})
}