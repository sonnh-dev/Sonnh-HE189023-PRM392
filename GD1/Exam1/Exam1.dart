import 'dart:async';

abstract class Entity {
  final String id;

  Entity(this.id);
}

class Message extends Entity {
  final String content;

  Message(String id, this.content) : super(id);

  @override
  String toString() => "Msg[$id]:$content";
}

abstract class BaseRepository {}

mixin SyncLogger on BaseRepository {
  void logSync(String msg) {
    print("[LOG]: $msg");
  }
}

class MessageRepository extends BaseRepository with SyncLogger {
  Stream<Message> syncMessages() async* {
    for (int i = 1; i < 3; i++) {
      await Future.delayed(Duration(milliseconds: 300));
      yield Message(i.toString(), "Nội dung $i");
      logSync("Đang đồng bộ tin nhắn $i");
    }
  }
}

void main() {
  var repo = MessageRepository();
  print("Bắt đầu đồng bộ...");
  // asBroadcastSteam sẽ sử dụng để nhận nhiều listener.
  var stream = repo.syncMessages().asBroadcastStream();
  stream.listen((msg) => print("UI 1 hiển thị: $msg"));
  stream.listen((msg) => print("UI 2 hiển thị: $msg"));
}
