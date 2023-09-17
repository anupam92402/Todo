class Task {
  String title;
  bool isCompleted;
  String date; // Change data type to String

  Task({
    required this.title,
    this.isCompleted = false,
    required this.date, // Include date as a string
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'date': date, // Store date as a string directly
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isCompleted: json['isCompleted'],
      date: json['date'], // Date is stored as a string
    );
  }
}