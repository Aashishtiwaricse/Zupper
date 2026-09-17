import 'package:get/get.dart';
import 'package:zuperr/Database/notification_db.dart';
import 'package:zuperr/Models/SimilarJobs/Notifications/notification_model.dart';





class NotificationController extends GetxController {


  static NotificationController get to =>
      Get.find<NotificationController>();


  final notifications =
      <NotificationModel>[].obs;


  final unreadCount =
      0.obs;



  @override
  void onInit() {

    super.onInit();

    loadNotifications();

  }



  // Load notifications from Hive

  void loadNotifications() {

    final data =
        NotificationDB.instance.getAll();


    notifications.assignAll(data);


    _updateUnreadCount();

  }





  // Add new notification

  Future<void> addNotification({

    required String title,

    required String body,

    String type = "general",

    String route = "",

    Map<String,dynamic>? data,


  }) async {


    await NotificationDB.instance.save(

      title:title,

      body:body,

      type:type,

      route:route,

      data:data,

    );


    loadNotifications();


  }





  // Delete single notification

  Future<void> deleteNotification(
      NotificationModel notification
      ) async {


    await NotificationDB.instance.delete(
      notification,
    );


    notifications.remove(notification);


    _updateUnreadCount();

  }





  // Clear all notifications

  Future<void> clearAll() async {


    await NotificationDB.instance.clearAll();


    notifications.clear();


    unreadCount.value = 0;

  }





  // Mark as read

  Future<void> markRead(
      NotificationModel notification
      ) async {


    await NotificationDB.instance.markRead(
      notification,
    );


    notification.isRead = true;


    notifications.refresh();


    _updateUnreadCount();

  }





  // Mark unread

  Future<void> markUnread(
      NotificationModel notification
      ) async {


    await NotificationDB.instance.markUnread(
      notification,
    );


    notification.isRead = false;


    notifications.refresh();


    _updateUnreadCount();

  }





  void _updateUnreadCount(){


    unreadCount.value =
        NotificationDB.instance.unreadCount();


  }


}