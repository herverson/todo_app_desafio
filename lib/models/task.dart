class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime date;
  final String notes;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.date,
    required this.notes,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? date,
    String? notes,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }
}
