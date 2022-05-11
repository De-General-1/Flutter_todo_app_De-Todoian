class Todo {
  int id;
  int userId;
  final String title;
  DateTime creationDate;
  DateTime dueOn;
  final String status;
  bool isChecked;

  //constructor
  Todo({
    this.id,
    this.userId,
    this.title,
    this.creationDate,
    this.dueOn,
    this.status,
    this.isChecked,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'creationDate': creationDate.toString(),
      'isChecked': isChecked ? 1 : 0,
      'dueOn': dueOn.toString(),
      'status': status,
    };
  }

  //For debugging
  @override
  String toString() {
    return 'Todo(id: $id, title : $title, creationDate: $creationDate, isChecked:$isChecked, dueOn: $dueOn, userId: $userId)';
  }
}
