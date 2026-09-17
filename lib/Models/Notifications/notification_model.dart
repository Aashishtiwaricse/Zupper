import 'package:hive/hive.dart';




@HiveType(typeId: 1)
class NotificationModel extends HiveObject {


  @HiveField(0)
  String id;


  @HiveField(1)
  String title;


  @HiveField(2)
  String body;


  @HiveField(3)
  DateTime createdAt;


  @HiveField(4)
  bool isRead;


  @HiveField(5)
  String type;


  @HiveField(6)
  String route;


  @HiveField(7)
  String? data;



  NotificationModel({

    required this.id,

    required this.title,

    required this.body,

    required this.createdAt,

    this.isRead = false,

    this.type = "",

    this.route = "",

    this.data,

  });

}