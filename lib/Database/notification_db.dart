import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:zuperr/Models/SimilarJobs/Notifications/notification_model.dart';
import 'dart:convert';

class NotificationDB {
  NotificationDB._();

  static final NotificationDB instance = NotificationDB._();

  static const String boxName = "notifications";

  late Box<NotificationModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<NotificationModel>(boxName);
  }

  Box<NotificationModel> get box => _box;

  //----------------------------------------------------
  // Save Notification
  //----------------------------------------------------

Future<void> save({
  required String title,
  required String body,
  String type = "general",
  String route = "",
  Map<String, dynamic>? data,
}) async {

  final notification = NotificationModel(

    id: const Uuid().v4(),

    title: title,

    body: body,

    createdAt: DateTime.now(),

    isRead: false,

    type: type,

    route: route,

    data: data == null
        ? null
        : jsonEncode(data),

  );


  await _box.add(notification);
}

  //----------------------------------------------------
  // Get All Notifications
  //----------------------------------------------------

  List<NotificationModel> getAll() {
    final list = _box.values.toList();

    list.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return list;
  }

  //----------------------------------------------------
  // Delete One
  //----------------------------------------------------

  Future<void> delete(NotificationModel notification) async {
    await notification.delete();
  }

  //----------------------------------------------------
  // Clear All
  //----------------------------------------------------

  Future<void> clearAll() async {
    await _box.clear();
  }

  //----------------------------------------------------
  // Mark Read
  //----------------------------------------------------

  Future<void> markRead(NotificationModel notification) async {
    notification.isRead = true;
    await notification.save();
  }

  //----------------------------------------------------
  // Mark Unread
  //----------------------------------------------------

  Future<void> markUnread(NotificationModel notification) async {
    notification.isRead = false;
    await notification.save();
  }

  //----------------------------------------------------
  // Total Count
  //----------------------------------------------------

  int totalCount() {
    return _box.length;
  }

  //----------------------------------------------------
  // Unread Count
  //----------------------------------------------------

  int unreadCount() {
    return _box.values.where((e) => !e.isRead).length;
  }

  //----------------------------------------------------
  // Find by ID
  //----------------------------------------------------

  NotificationModel? find(String id) {
    try {
      return _box.values.firstWhere(
        (e) => e.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  //----------------------------------------------------
  // Latest Notification
  //----------------------------------------------------

  NotificationModel? latest() {
    if (_box.isEmpty) return null;

    final list = getAll();

    return list.first;
  }
}