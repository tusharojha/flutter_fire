class Note {
  String uid, title;
  bool completed;

  Note.fromMap(Map m)
      : uid = m['uid'].toString(),
        title = m['title'].toString(),
        completed = m['completed'] as bool;
}
