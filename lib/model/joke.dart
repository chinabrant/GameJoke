import 'av_object.dart';
import 'user.dart';
import 'av_file.dart';
import 'game.dart';

/*
* 攻略 model
* */
class Joke extends AVObject {

  String content;       // 标题
  AVFile image;       // 封面图片
  User user;         // 创建人
  Game game;
  bool hidden;

  Joke({
    this.user,
    this.content,
    this.image,
    this.game,
    this.hidden,
  });

  Joke.fromMap(Map<String, dynamic> map) : super.fromMap(map) {

    this.user = User.fromMap(map['user']);
    this.image = map['image'] != null ? new AVFile.fromMap(map['image']) : null;
    this.content = map['content'];
    this.game = Game.fromMap(map['game']);
    this.hidden = map['hidden'];
  }


}