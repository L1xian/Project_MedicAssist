import 'package:blog_app/features/activity_tracking/data/activity_model.dart';
import 'package:hive/hive.dart';

abstract interface class ActivityLocalDataSource {
  void addActivity(ActivityModel activity);
  List<ActivityModel> getWeeklyActivity(String type);
  void clearOldActivity();
}

class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  final Box box;

  ActivityLocalDataSourceImpl(this.box);

  @override
  void addActivity(ActivityModel activity) {
    // Add new activity
    final String key = '${activity.type}_${activity.date.millisecondsSinceEpoch}';
    box.put(key, activity.toJson());
    
    // Clean up to keep only last 7 days
    clearOldActivity();
  }

  @override
  List<ActivityModel> getWeeklyActivity(String type) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final List<ActivityModel> activities = [];
    
    for (var key in box.keys) {
      if (key.toString().startsWith(type)) {
        final activity = ActivityModel.fromJson(box.get(key));
        if (activity.date.isAfter(weekAgo)) {
          activities.add(activity);
        }
      }
    }
    
    // Sort by date
    activities.sort((a, b) => a.date.compareTo(b.date));
    return activities;
  }

  @override
  void clearOldActivity() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final keysToDelete = <String>[];
    
    for (var key in box.keys) {
      final activity = ActivityModel.fromJson(box.get(key));
      if (activity.date.isBefore(weekAgo)) {
        keysToDelete.add(key.toString());
      }
    }
    
    for (var key in keysToDelete) {
      box.delete(key);
    }
  }
}
