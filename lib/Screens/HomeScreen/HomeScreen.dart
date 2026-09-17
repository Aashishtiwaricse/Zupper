import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Screens/HomeScreen/CategorySelectorDialog/CategorySelectorDialog.dart';
import 'package:zuperr/Screens/HomeScreen/HomeScreenWidgets/homeScreenJobsCard.dart';
import 'package:zuperr/Screens/HomeScreen/SearchResultsScreen.dart';
import 'package:zuperr/Screens/HomeScreen/allJobs.dart' show AllJobsScreen;
import 'package:zuperr/Screens/HomeScreen/categoryJobsScreen.dart';
import 'package:zuperr/Screens/HomeScreen/filterDrawer.dart';
import 'package:zuperr/Screens/HomeScreen/notificationScreen.dart';
import 'package:zuperr/Screens/ProfileScreen/userProfile.dart';
import 'package:zuperr/Services/CandidatesData/candidates.dart';
import 'package:zuperr/Services/Filter/filterService.dart';
import 'package:zuperr/Services/RecommendedJobs/recommendedJobs.dart';
import 'package:zuperr/Utils/AppConstants.dart';
import 'package:zuperr/Utils/enums.dart';

//Email: john.doe@example.com
//Password: TestPass@123

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const blue = Color(0xff1E6BE3);
  static const bg = Color(0xffF8F8F8);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<dynamic> recommendedJobs = [];
  List<dynamic> filteredJobs = [];
  bool isLoading = false;
  Map<String, dynamic>? candidateData;
  String? selectedCategory;
  final TextEditingController searchController = TextEditingController();
  bool isFilterApplied = false;
  bool isServiceSuspended = false;
  List<String> selectedCategories = [];
  List<dynamic> get displayJobs {
    if (isFilterApplied) {
      return filteredJobs;
    }
    return recommendedJobs;
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  List<dynamic> get recommendedDisplayJobs {
    List<dynamic> jobs = isFilterApplied ? filteredJobs : recommendedJobs;

    if (selectedFilter == RecommendedFilter.all) {
      return jobs;
    }

    return jobs.where((job) {
      return selectedCategories.contains(job["jobCategory"]);
    }).toList();
  }

  Future<void> refreshData() async {
    await Future.wait([loadRecommendedJobs(), loadCandidateData()]);
  }

  Future<void> loadCandidateData() async {
    final data = await CandidateService.getCandidateData();
    print('from home screen');

    print(
      selectedCategories = List<String>.from(data?["selectedJobCategories"]),
    );

    if (mounted) {
      setState(() {
        candidateData = data;

        selectedCategories = List<String>.from(
          data?["selectedJobCategories"] ?? [],
        );
      });
    }
  }

  Future<void> loadRecommendedJobs() async {
    setState(() {
      isLoading = true;
    });

    final jobs = await RecommendedJobsService.getRecommendedJobs(context);
    print("recommend jobs");
    print(jobs);

    if (mounted) {
      setState(() {
        recommendedJobs = jobs;
        isLoading = false;
      });
    }
  }

  static const bg = Color(0xffF8F8F8);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final availableCardHeight = screenHeight * 0.68;
    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Headersection(
              candidateData: candidateData,
              recommendedJobs: recommendedJobs,
              onFilterApplied: (List<dynamic> jobs) {
                setState(() {
                  filteredJobs = jobs;
                  isFilterApplied = true;
                });
              },
            ),
            recommendedJobs.isEmpty
                ? _buildLoadingOrEmptyState()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const SectionTitle("Quick Access"),
                        const SizedBox(height: 18),
                        QuickAccessRow(
                          jobs: recommendedJobs,
                          selectedCategories: selectedCategories,
                          onCategoryTap: (category) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          onCategoriesChanged: () async {
                            await loadCandidateData();
                          },
                        ),
                        const SizedBox(height: 34),
                        RecommendedHeader(jobs: recommendedDisplayJobs),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<RecommendedFilter>(
                              isExpanded: true,
                              value: selectedFilter,
                              items: const [
                                DropdownMenuItem(
                                  value: RecommendedFilter.all,
                                  child: Text("All Jobs"),
                                ),
                                DropdownMenuItem(
                                  value: RecommendedFilter.selectedCategory,
                                  child: Text("Selected Categories"),
                                ),
                              ],
                              onChanged: (value) async {
                                if (value == null) return;

                                setState(() {
                                  selectedFilter = value;
                                });

                                // Refresh immediately
                                await refreshData();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                       if (isLoading)
  const Center(
    child: CircularProgressIndicator(),
  )
else if (recommendedDisplayJobs.isEmpty)
  SizedBox(
    height: 300,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_off_outlined,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            selectedFilter == RecommendedFilter.all
                ? "No Jobs Found"
                : "No Category Jobs Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            selectedFilter == RecommendedFilter.all
                ? "There are no jobs available right now."
                : "No jobs are available in your selected categories.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    ),
  )
else
  SizedBox(
    height: availableCardHeight,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: recommendedDisplayJobs.length,
      separatorBuilder: (_, _) => const SizedBox(width: 16),
      itemBuilder: (context, index) {
        return JobCard(
          job: recommendedDisplayJobs[index],
        );
      },
    ),
  ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOrEmptyState() {
    if (isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              "No Jobs Available",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Pull down or tap refresh to try again",
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: loadRecommendedJobs,
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}

class Headersection extends StatefulWidget {
  final Map<String, dynamic>? candidateData;
  final List<dynamic> recommendedJobs;
  final Function(List<dynamic>) onFilterApplied;

  const Headersection({
    super.key,
    required this.candidateData,
    required this.recommendedJobs,
    required this.onFilterApplied,
  });

  @override
  State<Headersection> createState() => _HeadersectionState();
}

class _HeadersectionState extends State<Headersection> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> searchJobs(String query) async {
    if (query.trim().isEmpty) return;

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/employee/jobs/search"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"searchText": query, "page": 1, "limit": 10}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _searchController.clear();

      // Replace "jobs" with the correct key from your API if needed.
      final List<dynamic> jobs = List<dynamic>.from(
        data["jobs"] ?? data["data"] ?? [],
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultsScreen(searchText: query, jobs: jobs),
        ),
      );
    }
  }

  String currentLocation = "";
  bool isGettingLocation = false;
  Future<void> getCurrentLocation() async {
    setState(() {
      isGettingLocation = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enable location services")),
      );

      setState(() {
        isGettingLocation = false;
      });

      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );

      setState(() {
        isGettingLocation = false;
      });

      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      final location =
          "${place.locality ?? place.subAdministrativeArea ?? ""}, ${place.administrativeArea ?? ""}";

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("current_location", location);
      await prefs.setString("current_location", location);
      await prefs.setDouble("latitude", position.latitude);
      await prefs.setDouble("longitude", position.longitude);

      setState(() {
        currentLocation = location;
        isGettingLocation = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final savedLocation = prefs.getString("current_location");

    if (savedLocation != null && savedLocation.isNotEmpty) {
      setState(() {
        currentLocation = savedLocation;
      });
    } else {
      // If nothing is saved, fetch from GPS
      getCurrentLocation();
    }
  }

  String buildFilterSearchText(Map<String, Set<String>> selectedFilters) {
    final List<String> values = [];

    for (final entry in selectedFilters.entries) {
      for (final value in entry.value) {
        if (value.trim().isNotEmpty) {
          values.add(value.trim());
        }
      }
    }

    return values.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final String? profileImage = widget.candidateData?['profilePicture'];

    return Container(
      // height: 430,
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: HomeScreen.blue,
        image: DecorationImage(
          image: AssetImage("assets/Head.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Zuperr",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationScreen()),
                  );
                },
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProfileScreen(candidateData: widget.candidateData),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      (profileImage != null && profileImage.isNotEmpty)
                      ? NetworkImage(profileImage)
                      : null,
                  child: (profileImage == null || profileImage.isEmpty)
                      ? const Icon(Icons.person, size: 30, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.candidateData?['firstname'] ?? ''} ${widget.candidateData?['lastname'] ?? ''}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: getCurrentLocation,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 4),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            currentLocation.isNotEmpty
                                ? currentLocation
                                : "${widget.candidateData?['address']?['district'] ?? ''}"
                                      "${widget.candidateData?['address']?['state'] != null ? ', ${widget.candidateData!['address']['state']}' : ''}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),

                        if (isGettingLocation)
                          const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 34),
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: .18),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Icon(Icons.search, color: Colors.grey, size: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: "Jobs, Company, Skill...",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        searchJobs(value);
                      }
                    },
                  ),
                ),
                GestureDetector(
               onTap: () {
    FilterDrawer.show(
      context,
      (selectedFilters) async {
        try {
          debugPrint("================================");
          debugPrint("FILTERS SELECTED FROM DRAWER:");
          debugPrint(selectedFilters.toString());
          debugPrint("================================");

          if (selectedFilters.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please select at least one filter"),
              ),
            );
            return;
          }

          final jobs = await FilterService.searchJobsByFilters(
            selectedFilters,
          );

          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchResultsScreen(
                searchText: "",
                jobs: jobs,
              ),
            ),
          );
        } catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to search jobs: $e"),
            ),
          );
        }
      },
    );
  },
                  child: Image.asset(
                    'assets/filter.png',
                    width: 60,
                    height: 35,

                    //color: HomeScreen.blue,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    );
  }
}

// Create in Part 2

class QuickAccessRow extends StatefulWidget {
  final List<dynamic> jobs;
  final Function(String) onCategoryTap;
  final List<String> selectedCategories;
  final Future<void> Function() onCategoriesChanged;
  const QuickAccessRow({
    super.key,
    required this.jobs,
    required this.selectedCategories,
    required this.onCategoryTap,
    required this.onCategoriesChanged,
  });
  @override
  State<QuickAccessRow> createState() => _QuickAccessRowState();
}

class _QuickAccessRowState extends State<QuickAccessRow> {
  Future<void> _openCategorySelector() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (_) =>
          CategorySelectorDialog(selectedCategories: widget.selectedCategories),
    );

    if (result != null) {
      await widget.onCategoriesChanged();
    }
  }

  List<Color> quickCardColors = [
    Color(0xFF2F80ED), // Blue
    Color(0xFFF2994A), // Orange
    Color(0xFFEB5757), // Red
    Color(0xFF27AE60), // Green
    Color(0xFF9B51E0), // Purple
    Color(0xFF00B8D9), // Cyan
    Color(0xFFFF6F61), // Coral
    Color(0xFF6C63FF), // Indigo
    Color(0xFFFFC107), // Amber
    Color(0xFF26A69A), // Teal
  ];
  @override
  Widget build(BuildContext context) {
    final Map<String, int> counts = {};

    for (var job in widget.jobs) {
      final category = job["jobCategory"] ?? "Other";

      if (widget.selectedCategories.contains(category)) {
        counts[category] = (counts[category] ?? 0) + 1;
      }
    }

    final entries = widget.selectedCategories.map((category) {
      return MapEntry(category, counts[category] ?? 0);
    }).toList();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length + 1,
        itemBuilder: (context, index) {
          if (index == entries.length) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _EditCategoryCard(onTap: _openCategorySelector),
            );
          }

          final entry = entries[index];

          final categoryJobs = widget.jobs.where((job) {
            return job["jobCategory"] == entry.key;
          }).toList();

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: QuickCard(
              title: entry.key,
              color: quickCardColors[index % quickCardColors.length],
              count: entry.value,
              onTap: () {
                widget.onCategoryTap(entry.key);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryJobsScreen(
                      title: entry.key,
                      jobs: categoryJobs,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

///
/// Edit Card
///
class _EditCategoryCard extends StatelessWidget {
  final VoidCallback onTap;

  const _EditCategoryCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          border: Border.all(color: Colors.blue, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.edit, size: 22, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              "Edit Categories",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickCard extends StatelessWidget {
  final String title;
  final Color color;
  final int count;
  final VoidCallback onTap;

  const QuickCard({
    super.key,
    required this.title,
    required this.color,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: 165,
          height: 80,
          decoration: BoxDecoration(
            color: color.withOpacity(.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(.18), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.12),
                blurRadius: 14,
                offset: const Offset(3, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff111111),
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "$count Jobs",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecommendedHeader extends StatelessWidget {
  final List<dynamic> jobs;

  const RecommendedHeader({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Recommended Jobs",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xffECECEC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("${jobs.length}"),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AllJobsScreen(jobs: jobs)),
            );
          },
          child: const Text(
            "See all",
            style: TextStyle(
              color: HomeScreen.blue,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
