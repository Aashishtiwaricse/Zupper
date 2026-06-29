import 'package:flutter/material.dart';

class CustomVisibilityDropdown extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomVisibilityDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomVisibilityDropdown> createState() =>
      _CustomVisibilityDropdownState();
}

class _CustomVisibilityDropdownState
    extends State<CustomVisibilityDropdown>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;

  late AnimationController _controller;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _iconAnimation =
        Tween<double>(begin: 0, end: 0.5).animate(_controller);
  }

  void toggle() {
    setState(() {
      isOpen = !isOpen;

      if (isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        GestureDetector(
          onTap: toggle,
          child: Container(
            height: 58,
            padding:
                const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xffD9D9D9),
              ),
            ),
            child: Row(
              children: [

                Expanded(
                  child: Text(
                    widget.value,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xff555555),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                RotationTransition(
                  turns: _iconAnimation,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 28,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

        AnimatedCrossFade(
          firstChild: const SizedBox(),
          secondChild: Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: widget.items.map((e) {
                final selected = widget.value == e;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    widget.onChanged(e);

                    setState(() {
                      isOpen = false;
                    });

                    _controller.reverse();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    child: Row(
                      children: [

                        Expanded(
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: selected
                                  ? const Color(0xff1E6BE3)
                                  : Colors.black87,
                            ),
                          ),
                        ),

                        if (selected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xff1E6BE3),
                            size: 22,
                          )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          crossFadeState: isOpen
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}