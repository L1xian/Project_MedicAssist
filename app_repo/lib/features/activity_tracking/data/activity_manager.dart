import 'package:blog_app/features/activity_tracking/data/activity_local_data_source.dart';
import 'package:blog_app/features/activity_tracking/data/activity_model.dart';

class ActivityManager {
  final ActivityLocalDataSource _localDataSource;

  ActivityManager(this._localDataSource);

  void updateActivity(String type, double value) {
    final activity = ActivityModel(
      value: value,
      date: DateTime.now(),
      type: type,
    );
    _localDataSource.addActivity(activity);
    _localDataSource.clearOldActivity();
  }

  List<ActivityModel> getWeeklyData(String type) {
    return _localDataSource.getWeeklyActivity(type);
  }
}
