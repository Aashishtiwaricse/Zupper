import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zuperr/Controllers/Notification/notification_controller.dart';
import 'package:zuperr/Models/SimilarJobs/Notifications/notification_model.dart';



class NotificationTile extends StatelessWidget {

  final NotificationModel notification;


  const NotificationTile({
    super.key,
    required this.notification,
  });


  @override
  Widget build(BuildContext context) {

    final controller =
        Get.find<NotificationController>();


    return GestureDetector(

      onTap: () async {

        await controller.markRead(notification);


        if(notification.route.isNotEmpty){

          Get.toNamed(
            notification.route,
            arguments: notification.data,
          );

        }

      },


      child: Container(

        color: notification.isRead
            ? Colors.white
            : const Color(0xffF1F6FF),


        padding:
        const EdgeInsets.symmetric(

          horizontal:20,

          vertical:20,

        ),



        child: Row(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children:[


            // Unread indicator

            if(!notification.isRead)

              Container(

                margin:
                const EdgeInsets.only(
                  top:18,
                  right:12,
                ),


                height:10,

                width:10,


                decoration:
                const BoxDecoration(

                  color:
                  Color(0xff1E6BE3),

                  shape:
                  BoxShape.circle,

                ),

              ),



            // Avatar

            Container(

              height:45,

              width:45,


              decoration:
              BoxDecoration(

                color:
                const Color(0xff1954A6),


                borderRadius:
                BorderRadius.circular(14),

              ),



              child:
              Center(

                child:Text(

                  _getInitials(),


                  style:
                  const TextStyle(

                    color:
                    Colors.white,

                    fontSize:16,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),

              ),

            ),



            const SizedBox(
              width:15,
            ),



            Expanded(

              child:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[



                  Row(

                    children:[


                      Expanded(

                        child:Text(

                          notification.title,


                          maxLines:1,

                          overflow:
                          TextOverflow.ellipsis,


                          style:
                          const TextStyle(

                            fontSize:15,

                            fontWeight:
                            FontWeight.w700,

                            color:
                            Color(0xff202124),

                          ),

                        ),

                      ),



                      Text(

                        _timeAgo(
                          notification.createdAt,
                        ),


                        style:
                        const TextStyle(

                          fontSize:12,

                          color:
                          Color(0xff6A6E76),

                        ),

                      ),



                    ],

                  ),



                  const SizedBox(
                    height:8,
                  ),



                  Text(

                    notification.body,


                    maxLines:3,


                    overflow:
                    TextOverflow.ellipsis,


                    style:
                    const TextStyle(

                      fontSize:14,

                      height:1.35,

                      color:
                      Color(0xff414651),

                    ),

                  ),



                ],

              ),

            ),



            const SizedBox(
              width:10,
            ),



            GestureDetector(

              onTap:(){

                controller.deleteNotification(
                  notification,
                );

              },


              child:
              const Icon(

                Icons.close,

                size:20,

                color:
                Colors.grey,

              ),

            )


          ],

        ),

      ),

    );

  }



  String _getInitials(){

    if(notification.title.isEmpty){

      return "N";

    }


    final words =
        notification.title.split(" ");


    if(words.length == 1){

      return words[0][0].toUpperCase();

    }


    return
        "${words[0][0]}${words[1][0]}"
            .toUpperCase();

  }





  String _timeAgo(DateTime time){

    final diff =
        DateTime.now().difference(time);



    if(diff.inSeconds < 60){

      return "Just now";

    }


    if(diff.inMinutes < 60){

      return "${diff.inMinutes} min ago";

    }


    if(diff.inHours < 24){

      return "${diff.inHours} hour ago";

    }


    if(diff.inDays == 1){

      return "Yesterday";

    }


    if(diff.inDays < 7){

      return "${diff.inDays} days ago";

    }


    return
        "${time.day}/${time.month}/${time.year}";

  }

}