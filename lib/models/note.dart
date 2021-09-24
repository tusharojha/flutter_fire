class Note {
  String uid, title;
  bool completed;
  DateTime createdAt;

  Note.fromMap(Map m)
      : uid = m['uid'].toString(),
        title = m['title'].toString(),
        completed = m['completed'] as bool,
        createdAt = DateTime.fromMillisecondsSinceEpoch(m['createdAt']);
}
