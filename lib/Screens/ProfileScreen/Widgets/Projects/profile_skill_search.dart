import 'package:flutter/material.dart';
import 'package:zuperr/Models/skillsModel/skills.dart';

class ProfileSkillSearch extends StatefulWidget {

  final List<Skill> allSkills;

  final List<Skill> selectedSkills;

  final Function(List<Skill>) onChanged;

  const ProfileSkillSearch({
    super.key,
    required this.allSkills,
    required this.selectedSkills,
    required this.onChanged,
  });

  @override
  State<ProfileSkillSearch> createState() =>
      _ProfileSkillSearchState();

}
class _ProfileSkillSearchState
    extends State<ProfileSkillSearch> {

  final controller = TextEditingController();

  List<Skill> filtered = [];

  void search(String value) {

  if(value.isEmpty){

    filtered=[];

    setState(() {});

    return;

  }

  filtered=widget.allSkills.where((e){

    return e.name
        .toLowerCase()
        .contains(value.toLowerCase())

        &&

        !widget.selectedSkills
            .any((s)=>s.id==e.id);

  }).toList();

  setState(() {});
}
@override
Widget build(BuildContext context) {

  return Column(

    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      TextField(

        controller: controller,

        onChanged: search,

        decoration: InputDecoration(

          prefixIcon: const Icon(Icons.search),

          hintText: "Search Skills",

          border: OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(14),

          ),
        ),
      ),

      const SizedBox(height: 12),

      Wrap(

        spacing: 8,

        runSpacing: 8,

        children: widget.selectedSkills
            .map(

              (skill)=>Chip(

                label: Text(skill.name),

                onDeleted: (){

                  widget.selectedSkills.remove(skill);

                  widget.onChanged(
                    widget.selectedSkills,
                  );

                  setState(() {});

                },

              ),

            ).toList(),

      ),

      if(filtered.isNotEmpty)

        Container(

          margin: const EdgeInsets.only(top:10),

          constraints:
              const BoxConstraints(
            maxHeight:200,
          ),

          decoration: BoxDecoration(

            border: Border.all(
              color: Colors.grey.shade300,
            ),

            borderRadius:
                BorderRadius.circular(12),

          ),

          child: ListView.builder(

            shrinkWrap:true,

            itemCount: filtered.length,

            itemBuilder: (_,i){

              final skill=filtered[i];

              return ListTile(

                title: Text(skill.name),

                trailing:
                    const Icon(Icons.add),

                onTap: (){

                  widget.selectedSkills
                      .add(skill);

                  controller.clear();

                  filtered=[];

                  widget.onChanged(
                    widget.selectedSkills,
                  );

                  setState(() {});

                },

              );

            },

          ),

        ),
    ],
  );
}
    }