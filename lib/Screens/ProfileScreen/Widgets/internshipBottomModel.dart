import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zuperr/Models/InternshipModel/internship.dart';
import 'package:zuperr/Models/skillsModel/skills.dart';
import 'package:zuperr/Services/PofileUpdate/profile_update.dart';
import 'package:zuperr/Services/skills/SkillService.dart';

class InternshipBottomSheet extends StatefulWidget {
  final InternshipModel? internship;
  final int? index;
  final List<dynamic> internships;
  final VoidCallback onSaved;

  const InternshipBottomSheet({
    super.key,
    this.internship,
    this.index,
    required this.internships,
    required this.onSaved,
  });

  @override
  State<InternshipBottomSheet> createState() => _InternshipBottomSheetState();
}

class _InternshipBottomSheetState extends State<InternshipBottomSheet> {
  final companyController = TextEditingController();

  final roleController = TextEditingController();

  final projectController = TextEditingController();

  final descriptionController = TextEditingController();

  final urlController = TextEditingController();

  final searchController = TextEditingController();

  final fromController = TextEditingController();

  final toController = TextEditingController();

  Map<String, dynamic> internshipJson() {
  return {
    "companyName": companyController.text.trim(),
    "role": roleController.text.trim(),
    "duration": {
      "from": convertMonth(fromController.text),
      "to": convertMonth(toController.text),
    },
    "projectName": projectController.text.trim(),
    "description": descriptionController.text.trim(),
    "keySkills": skillString(),
    "projectURL": urlController.text.trim(),
  };
}

  List<Skill> allSkills = [];

  List<Skill> filteredSkills = [];

  List<Skill> selectedSkills = [];

  bool loading = true;

  bool saving = false;
  Future<void> saveInternship() async {

  if (!formKey.currentState!.validate()) {
    return;
  }

  saving = true;

  setState(() {});

  List<dynamic> internships =
      List.from(widget.internships);

  if (widget.index == null) {

    internships.add(
      internshipJson(),
    );

  } else {

    internships[widget.index!] =
        internshipJson();

  }

  final success =
      await ProfileUpdateService().updateProfile(
    data: {
      "internships": internships,
    },
  );

  saving = false;

  if (!mounted) return;

  setState(() {});

  if (success) {

    widget.onSaved();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.index == null
              ? "Internship Added"
              : "Internship Updated",
        ),
      ),
    );

  } else {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Unable to save internship"),
      ),
    );

  }
}
  String convertMonth(String value) {

  final date = DateFormat(
    "MMM yyyy",
  ).parse(value);

  return DateFormat(
    "yyyy-MM-01",
  ).format(date);
}

  final formKey = GlobalKey<FormState>();
  Future<void> pickMonth(TextEditingController controller) async {
    DateTime initial = DateTime.now();

    if (controller.text.isNotEmpty) {
      try {
        initial = DateFormat("MMM yyyy").parse(controller.text);
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    controller.text = DateFormat("MMM yyyy").format(picked);
  }

  @override
  void initState() {
    super.initState();

    loadSkills();

    if (widget.internship != null) {
      fillData(widget.internship!);
    }
  }

  void fillData(InternshipModel item) {
    companyController.text = item.companyName ?? "";

    roleController.text = item.role ?? "";

    projectController.text = item.projectName ?? "";

    descriptionController.text = item.description ?? "";

    urlController.text = item.projectURL ?? "";

    fromController.text = formatMonth(item.duration?.from);

    toController.text = formatMonth(item.duration?.to);

    if ((item.keySkills ?? "").isNotEmpty) {
      final list = item.keySkills!.split(",");

      selectedSkills = list.map((e) => Skill(id: "", name: e.trim())).toList();
    }
  }

  Future<void> loadSkills() async {
    allSkills = await SkillService.getAllSkills();

    filteredSkills = List.from(allSkills);

    loading = false;

    if (mounted) {
      setState(() {});
    }
  }

  String formatMonth(String? date) {
    if (date == null || date.isEmpty) {
      return "";
    }

    return DateFormat("MMM yyyy").format(DateTime.parse(date));
  }

  @override
  void dispose() {
    companyController.dispose();

    roleController.dispose();

    projectController.dispose();

    descriptionController.dispose();

    urlController.dispose();

    searchController.dispose();

    fromController.dispose();

    toController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: bottom),
      child: DraggableScrollableSheet(
        initialChildSize: .92,
        minChildSize: .70,
        maxChildSize: .96,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  Container(
                    width: 70,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    widget.internship == null
                        ? "Add Internship"
                        : "Edit Internship",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Highlight your internship experience, projects and technologies used.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        buildCompanyField(),

                        const SizedBox(height: 20),

                        buildRoleField(),

                        const SizedBox(height: 20),

                        buildDuration(),

                        const SizedBox(height: 20),

                        buildProjectName(),

                        const SizedBox(height: 20),

                        buildDescription(),

                        const SizedBox(height: 20),

                        buildSkillSearch(),

                        const SizedBox(height: 20),

                        buildProjectURL(),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  buildSaveButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
Widget buildSaveButton() {
  return SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: saving ? null : saveInternship,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff2563EB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: saving
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  widget.internship == null
                      ? "Add Internship"
                      : "Save Changes",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    ),
  );
}
  Widget buildCompanyField() {
    return TextFormField(
      controller: companyController,
      decoration: InputDecoration(
        labelText: "Company Name *",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Company name is required";
        }
        return null;
      },
    );
  }

  Widget buildRoleField() {
    return TextFormField(
      controller: roleController,
      decoration: InputDecoration(
        labelText: "Internship Role *",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Role is required";
        }
        return null;
      },
    );
  }

  Widget buildProjectName() {
    return TextFormField(
      controller: projectController,
      decoration: InputDecoration(
        labelText: "Project Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget buildDescription() {
    return TextFormField(
      controller: descriptionController,
      maxLines: 5,
      maxLength: 300,
      decoration: InputDecoration(
        labelText: "Description",
        alignLabelWithHint: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget buildProjectURL() {
    return TextFormField(
      controller: urlController,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        labelText: "Project URL",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        prefixIcon: const Icon(Icons.link),
      ),
    );
  }
Widget buildSkillSearch() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        "Skills Used",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),

      const SizedBox(height: 10),

      TextField(
        controller: searchController,
        onChanged: searchSkill,
        decoration: InputDecoration(
          hintText: "Search skills",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      const SizedBox(height: 12),

      if(selectedSkills.isNotEmpty)
        buildSelectedSkills(),

      if(filteredSkills.isNotEmpty)
        buildSuggestions(),
    ],
  );
}

void searchSkill(String value) {

  if(value.trim().isEmpty){

    filteredSkills=[];

    setState(() {});

    return;
  }

  filteredSkills=allSkills.where((skill){

    return skill.name
        .toLowerCase()
        .contains(value.toLowerCase())

        &&

        !selectedSkills.contains(skill);

  }).toList();

  setState(() {});
}
Widget buildSelectedSkills() {

  return Padding(

    padding: const EdgeInsets.only(bottom: 15),

    child: Wrap(

      spacing: 8,

      runSpacing: 8,

      children: selectedSkills.map((skill){

        return Chip(

          label: Text(skill.name),

          backgroundColor: Colors.blue.shade50,

          deleteIcon: const Icon(Icons.close,size:18),

          onDeleted: (){

            selectedSkills.remove(skill);

            setState(() {});

          },

        );

      }).toList(),

    ),

  );

}
Widget buildSuggestions() {

  return Container(

    constraints: const BoxConstraints(
      maxHeight: 220,
    ),

    decoration: BoxDecoration(

      border: Border.all(
        color: Colors.grey.shade300,
      ),

      borderRadius: BorderRadius.circular(12),

    ),

    child: ListView.separated(

      shrinkWrap: true,

      itemCount: filteredSkills.length,

      separatorBuilder: (_,_)=>Divider(height:1),

      itemBuilder: (_,index){

        final skill=filteredSkills[index];

        return ListTile(

          dense: true,

          title: Text(skill.name),

          trailing: const Icon(
            Icons.add_circle_outline,
            color: Colors.blue,
          ),

          onTap: (){

            selectedSkills.add(skill);

            filteredSkills.remove(skill);

            searchController.clear();

            filteredSkills=[];

            setState(() {});

          },

        );

      },

    ),

  );

}
String skillString(){

  return selectedSkills

      .map((e)=>e.name)

      .join(", ");

}
  Widget buildDuration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Internship Duration *",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: buildMonthField(
                controller: fromController,
                hint: "Start",
                onTap: () => pickMonth(fromController),
              ),
            ),

             Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.arrow_forward),
            ),

            Expanded(
              child: buildMonthField(
                controller: toController,
                hint: "End",
                onTap: () => pickMonth(toController),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildMonthField({
    required TextEditingController controller,
    required String hint,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: IgnorePointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: const Icon(Icons.calendar_month),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Required";
            }
            return null;
          },
        ),
      ),
    );
  }
}
