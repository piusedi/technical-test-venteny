enum TaskStatus {pending, inProgress, completed}

class Task {
	int? id;
	String title;
	String? description;
	DateTime dueDate;
	TaskStatus status;

	Task({
		this.id,
		required this.title,
		this.description,
		required this.dueDate,
		required this.status,
	});

	// Convert Task object to Map for SQLite storage
	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'title': title,
			'description': description,
			'dueDate': dueDate.toIso8601String(),
			'status': status.toString().split('.').last,
		};
	}

	// Convert Map back to Task object
	factory Task.fromMap(Map<String, dynamic> map) {
		return Task(
			id: map['id'],
			title: map['title'],
			description: map['description'],
			dueDate: DateTime.parse(map['dueDate']),
			status: TaskStatus.values.firstWhere(
				(e) => e.toString().split('.').last == map['status']
			),
		);
	}
}
