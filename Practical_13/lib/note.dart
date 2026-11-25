class Note {
  const Note({this.id, required this.text, required this.createdAt});
  final int? id;
  final String text;
  final DateTime createdAt;
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'text': text,
    'created_at': createdAt.toUtc().microsecondsSinceEpoch,
  };
  factory Note.fromMap(Map<String, Object?> row) => Note(
    id: row['id'] as int,
    text: row['text'] as String,
    createdAt: DateTime.fromMicrosecondsSinceEpoch(
      row['created_at'] as int,
      isUtc: true,
    ),
  );
}

String? noteValidator(String? text) =>
    text == null || text.trim().isEmpty ? 'Введіть текст нотатки' : null;
