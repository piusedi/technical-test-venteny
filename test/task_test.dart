import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/features/tasks/domain/models/task_model.dart';

void main() {
  group('Task Status Update', () {
    test('Should start with Pending status', () {
      final task = Task(title: 'Test Task', dueDate: DateTime.now(), status: TaskStatus.pending);
      expect(task.status, TaskStatus.pending);
    });
  });
}
