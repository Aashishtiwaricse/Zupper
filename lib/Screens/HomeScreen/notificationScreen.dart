import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zuperr/Screens/HomeScreen/Widgets/notification_tile.dart';

import '../../Controllers/Notification/notification_controller.dart';


class NotificationScreen extends StatelessWidget {

  NotificationScreen({super.key});


  final NotificationController controller =
      Get.find<NotificationController>();


  static const blue = Color(0xff1E6BE3);
  static const bg = Color(0xffF5F5F5);


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: bg,


      body: Column(

        children: [


          _header(),


          Expanded(

            child: Obx(() {


              if(controller.notifications.isEmpty){

                return _emptyState();

              }


              return RefreshIndicator(

                onRefresh: () async {

                  controller.loadNotifications();

                },


                child: ListView.separated(

                  padding: EdgeInsets.zero,


                  itemCount:
                      controller.notifications.length,


                  separatorBuilder: (_,__)=> const Divider(
                    height:1,
                    color: Color(0xffEEEEEE),
                  ),


                  itemBuilder:(context,index){


                    final notification =
                        controller.notifications[index];


                    return Dismissible(

                      key: Key(
                        notification.id,
                      ),


                      direction:
                      DismissDirection.endToStart,


                      background: Container(

                        alignment:
                        Alignment.centerRight,


                        padding:
                        const EdgeInsets.only(
                          right:25,
                        ),


                        color:
                        Colors.red,


                        child:
                        const Icon(
                          Icons.delete,
                          color:Colors.white,
                        ),

                      ),



                      onDismissed:(_){

                        controller.deleteNotification(
                          notification,
                        );

                      },


                      child:
                      NotificationTile(
                        notification:
                        notification,
                      ),

                    );

                  },


                ),

              );

            }),

          )

        ],

      ),

    );

  }





  Widget _header(){


    return Container(

      height:135,

      width:double.infinity,


      padding:
      const EdgeInsets.only(
        top:58,
        left:20,
        right:20,
      ),


      decoration:
      const BoxDecoration(

        image:
        DecorationImage(

          image:
          AssetImage(
            "assets/Head.png",
          ),

          fit:
          BoxFit.cover,

        ),

      ),



      child:Row(

        children:[


          GestureDetector(

            onTap:(){

              Get.back();

            },


            child:Container(

              height:38,

              width:38,


              decoration:
              BoxDecoration(

                color:
                Colors.white24,


                borderRadius:
                BorderRadius.circular(12),

              ),


              child:
              const Icon(

                Icons.arrow_back_ios_new,

                color:
                Colors.white,

                size:14,

              ),

            ),

          ),


          const SizedBox(
            width:18,
          ),


          const Expanded(

            child:Text(

              "Notifications",

              style:
              TextStyle(

                color:
                Colors.white,

                fontSize:24,

                fontWeight:
                FontWeight.w700,

              ),

            ),

          ),



          GestureDetector(

            onTap:(){

              controller.clearAll();

            },


            child:
            const Text(

              "Clear All",

              style:
              TextStyle(

                color:
                Colors.white,

                fontWeight:
                FontWeight.w600,

              ),

            ),

          )


        ],

      ),

    );

  }





  Widget _emptyState(){


    return const Center(

      child:Column(

        mainAxisSize:
        MainAxisSize.min,


        children:[


          Icon(

            Icons.notifications_none,

            size:70,

            color:
            Colors.grey,

          ),


          SizedBox(
            height:15,
          ),


          Text(

            "No Notifications Yet",

            style:
            TextStyle(

              fontSize:18,

              fontWeight:
              FontWeight.w600,

            ),

          ),


          SizedBox(
            height:8,
          ),


          Text(

            "We'll notify you when something arrives",

            style:
            TextStyle(
              color:Colors.grey,
            ),

          )

        ],

      ),

    );

  }

}