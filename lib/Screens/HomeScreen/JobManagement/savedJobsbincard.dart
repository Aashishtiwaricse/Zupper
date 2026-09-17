import 'package:flutter/material.dart';
import 'package:zuperr/Models/SavedJobsBin/savedJobsBin.dart';

class JobBinCard extends StatelessWidget {
  final SavedJobBin job;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback onRestore;
  


  const JobBinCard({
    super.key,
    required this.job,
    this.onTap,
      this.onDelete,required this.onRestore,


  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildCompanyLogo(),

                  const SizedBox(width: 14),


                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          job.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),


                        const SizedBox(height: 6),


                        Text(
                          job.companyName,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),


                        const SizedBox(height: 10),


                        Row(
                          children: [

                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),

                            const SizedBox(width: 5),


                            Expanded(
                              child: Text(
                                job.location,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),


                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Deleted",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),

                ],
              ),


              const SizedBox(height: 18),


              Row(
                children: [

                  Expanded(
                    child: _infoChip(
                      Icons.work_outline,
                      "${job.minimumExperienceInYears}-${job.maximumExperienceInYears} Years",
                    ),
                  ),


                  const SizedBox(width: 12),


                  Expanded(
                    child: _infoChip(
                      Icons.currency_rupee,
                      "${job.minimumSalaryLPA}-${job.maximumSalaryLPA} LPA",
                    ),
                  ),

                ],
              ),


              const SizedBox(height: 18),


              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.skills
                    .take(5)
                    .map(
                      (skill) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffEEF5FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            color: Color(0xff1E6BE3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height:18),
              Row(
  children: [
    Expanded(
      child: OutlinedButton.icon(
        onPressed: onRestore,
        icon: const Icon(
          Icons.restore,
          color: Colors.blue,
        ),
        label: const Text(
          "Restore",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    ),

    
  ],
),


SizedBox(
 width: double.infinity,
 height:50,

 child: ElevatedButton.icon(

   onPressed: () async {


     final confirm = await showDialog<bool>(
       context: context,

       builder:(context)=>AlertDialog(

         title: const Text(
           "Delete Permanently",
         ),

         content: const Text(
           "This job will be permanently removed.",
         ),

         actions:[

           TextButton(
             onPressed:(){
               Navigator.pop(
                 context,
                 false,
               );
             },

             child: const Text(
               "Cancel",
             ),
           ),


           TextButton(
             onPressed:(){

               Navigator.pop(
                 context,
                 true,
               );

             },

             child: const Text(
               "Delete",
               style: TextStyle(
                 color: Colors.red,
               ),
             ),
           ),

         ],

       ),
     );


     if(confirm == true){

        onDelete?.call();

     }


   },


   icon: const Icon(
     Icons.delete_forever,
   ),


   label: const Text(
     "Delete Permanently",
   ),


   style: ElevatedButton.styleFrom(
     backgroundColor: Colors.red,
     foregroundColor: Colors.white,

     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(14),
     ),
   ),

 ),

),

            ],
          ),
        ),
      ),
    );
  }



  Widget _buildCompanyLogo() {

    if(job.companyLogo != null &&
       job.companyLogo!.isNotEmpty){

      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          job.companyLogo!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_,_,_){
            return _buildAvatar();
          },
        ),
      );

    }


    return _buildAvatar();
  }



  Widget _buildAvatar(){

    final letter =
        job.companyName.isNotEmpty
        ? job.companyName[0].toUpperCase()
        : "C";


    return Container(
      width:60,
      height:60,
      alignment:Alignment.center,
      decoration:BoxDecoration(
        color: const Color(0xff1E6BE3),
        borderRadius:BorderRadius.circular(14),
      ),
      child:Text(
        letter,
        style:const TextStyle(
          color:Colors.white,
          fontSize:24,
          fontWeight:FontWeight.bold,
        ),
      ),
    );
  }



  Widget _infoChip(
      IconData icon,
      String text,
      ){

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal:12,
        vertical:10,
      ),
      decoration:BoxDecoration(
        color:Colors.grey.shade100,
        borderRadius:BorderRadius.circular(10),
      ),

      child:Row(
        children:[

          Icon(
            icon,
            size:18,
            color:const Color(0xff1E6BE3),
          ),

          const SizedBox(width:8),

          Expanded(
            child:Text(
              text,
              overflow:TextOverflow.ellipsis,
              style:const TextStyle(
                fontWeight:FontWeight.w500,
              ),
            ),
          ),

        ],
      ),
    );
  }

}