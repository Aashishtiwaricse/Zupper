import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TemplateCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const TemplateCard({
    super.key,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: selected
              ? const Color(0xff2970FF)
              : const Color(0xffDCE6F2),
          width: selected ? 2 : 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,

          child: Padding(
            padding: const EdgeInsets.all(28),

            child: Stack(
              children: [

                Padding(
                  padding: const EdgeInsets.only(right: 55),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff252B37),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          height: 1.5,
                          color: const Color(0xff6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 0,
                  right: 0,

                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),

                    child: selected
                        ? Container(
                            key: const ValueKey(true),

                            width: 20,
                            height: 20,

                            decoration: const BoxDecoration(
                              color: Color(0xff2970FF),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          )
                        : Container(
                            key: const ValueKey(false),
                            width: 40,
                            height: 40,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// class TemplateCard extends StatelessWidget {

//   final bool selected;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;

//   const TemplateCard({
//     super.key,
//     required this.selected,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {

//     return GestureDetector(

//       onTap: onTap,

//       child: AnimatedContainer(

//         duration: const Duration(milliseconds: 250),

//         margin: const EdgeInsets.only(bottom: 18),

//         padding: const EdgeInsets.all(20),

//         decoration: BoxDecoration(

//           color: Colors.white,

//           borderRadius: BorderRadius.circular(18),

//           border: Border.all(
//             color: selected
//                 ? AppColors.primary
//                 : AppColors.border,
//             width: selected ? 2 : 1,
//           ),

//           boxShadow: selected
//               ? [
//                   BoxShadow(
//                     color: AppColors.primary.withValues(alpha: .15),
//                     blurRadius: 15,
//                     offset: const Offset(0, 5),
//                   ),
//                 ]
//               : [],
//         ),

//         child: Row(

//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [

//             Expanded(
//               child: Column(

//                 crossAxisAlignment: CrossAxisAlignment.start,

//                 children: [

//                   Text(
//                     title,
//                     style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   Text(
//                     subtitle,
//                     style: AppTextStyle.small,
//                   ),
//                 ],
//               ),
//             ),

//             AnimatedSwitcher(

//               duration: const Duration(milliseconds: 200),

//               child: selected
//                   ? const CircleAvatar(
//                       radius: 10,
//                       backgroundColor: AppColors.primary,
//                       child: Icon(
//                         Icons.check,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                     )
//                   : const SizedBox(
//                       width: 28,
//                       height: 28,
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }