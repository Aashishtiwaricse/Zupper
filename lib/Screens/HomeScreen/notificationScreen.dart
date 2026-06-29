import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const blue = Color(0xff1E6BE3);
  static const bg = Color(0xffF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          /// HEADER
          Container(
            height: 135,
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 58,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Head.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                const Text(
                  "Notifications",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: 8,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color(0xffEEEEEE),
              ),
              itemBuilder: (context, index) {
                return const NotificationTile();
              },
            ),
          )
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: indexColor(),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// unread dot
          // Container(
          //   margin: const EdgeInsets.only(top: 18),
          //   height: 14,
          //   width: 14,
          //   decoration: const BoxDecoration(
          //     color: Color(0xff1954A6),
          //     shape: BoxShape.circle,
          //   ),
          // ),

          // const SizedBox(width: 18),

          /// avatar
          Container(
           // height: 22,
           // width: 22,
            decoration: BoxDecoration(
              color: const Color(0xff1954A6),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "AB",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Naukri Minis",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff6A6E76),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "15h",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff6A6E76),
                      ),
                    )
                  ],
                ),

                SizedBox(height: 12),

                Text(
                  "IT Employees’ unions accuse TCS of rights violation after retrenching 6,000 of its staff",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: Color(0xff414651),
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Color indexColor() {
    return const Color(0xffF8F8F8);
  }
}