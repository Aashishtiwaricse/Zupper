import 'package:flutter/material.dart';
import 'package:zuperr/Models/SavedJobsBin/savedJobsBin.dart';
import 'package:zuperr/Screens/HomeScreen/JobManagement/savedJobsbincard.dart';
import 'package:zuperr/Services/Jobs/BIn/deleteBinJob.dart';
import 'package:zuperr/Services/Jobs/BIn/restoreJobsFromBin.dart';
import 'package:zuperr/Services/Jobs/BIn/savedDeletedJobs.dart';


class SavedJobsBinScreen extends StatefulWidget {
  const SavedJobsBinScreen({super.key});

  @override
  State<SavedJobsBinScreen> createState() =>
      _SavedJobsBinScreenState();
}


class _SavedJobsBinScreenState
    extends State<SavedJobsBinScreen> {


List<SavedJobBin> jobs = [];
  bool loading = true;


  @override
  void initState() {
    super.initState();
    fetchBinJobs();
  }

Future<void> restoreJob(String id) async {
  final success = await restoreBinJob(id);

  if (!mounted) return;

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Job restored successfully"),
        backgroundColor: Colors.green,
      ),
    );

    // Refresh list immediately
    await fetchBinJobs();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to restore job"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Future<void> fetchBinJobs() async {

    setState(() {
      loading = true;
    });


    final data =
        await getSavedJobsBin();
        print("SCREEN BIN DATA LENGTH: ${data.length}");


    if(!mounted) return;


    setState(() {

      jobs = data;

      loading = false;

    });

  }
Future<void> deleteForever(String id) async {
  final success = await deleteBinJob(id);

  if (!mounted) return;

  if (success) {
    setState(() {
      jobs.removeWhere((job) => job.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Job permanently deleted"),
        backgroundColor: Colors.green,
      ),
    );
  } else {
    final retry = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 10),
            Text("Delete Failed"),
          ],
        ),
        content: const Text(
          "Unable to permanently delete this job.\n\nWould you like to try again?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          ),
        ],
      ),
    );

    if (retry == true && mounted) {
      await deleteForever(id);
    }
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF8F9FC),


      appBar: AppBar(

        title: const Text(
          "Saved Jobs Bin",
        ),

      ),


      body:

      loading

      ?

      const Center(
        child: CircularProgressIndicator(),
      )


      :

      jobs.isEmpty

      ?

      const Center(
        child: Text(
          "No deleted jobs",
          style: TextStyle(
            fontSize:18,
            fontWeight:FontWeight.w600,
          ),
        ),
      )


      :

      RefreshIndicator(

        onRefresh: fetchBinJobs,

        child: ListView.builder(

          itemCount: jobs.length,

          itemBuilder:(context,index){

  return JobBinCard(
  job: jobs[index],
  onDelete: () {
    deleteForever(jobs[index].id);
  },
  onRestore: () {
    restoreJob(jobs[index].id);
  },
);

          },

        ),

      ),

    );

  }

}