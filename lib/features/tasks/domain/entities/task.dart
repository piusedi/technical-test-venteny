import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
enum TaskStatus {
	@HiveField(0)
	pending,
	@HiveField(1)
	inProgress,
	@HiveField(2)
	completed,
}

@HiveType(typeId: 1)
class Task extends HiveObject {
	@HiveField(0)
	final String id;

	@HiveField(1)
	String title;

	@HiveField(2)
	String? description;

	@HiveField(3)
	DateTime dueDate;

	@HiveField(4)
	TaskStatus status;

	Task({
		required this.id,
		required this.title,
		this.description,
		required this.dueDate,
		this.status = TaskStatus.pending,
	});
}
