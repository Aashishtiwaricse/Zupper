import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:zuperr/Models/Company/CompanyResponse.dart';
import 'package:zuperr/Screens/Companies/companiesDetails.dart';
import 'package:zuperr/Services/Company/companyService.dart';
import 'package:zuperr/Services/CompanyReviewService/CompanyReviewService.dart';

import '../../Services/CandidatesData/candidates.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  CompaniesScreenState createState() => CompaniesScreenState();
}

class CompaniesScreenState extends State<CompaniesScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isPostingReview = false;
  List<Company> companies = [];
  List<Company> filteredCompanies = [];
  Map<String, dynamic>? candidateData;
  final TextEditingController otherDesignationController =
      TextEditingController();

  Company? selectedCompany;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    refreshData();

    searchController.addListener(searchCompanies);
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([loadCompanies(), loadCandidateData()]);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadCandidateData() async {
    final data = await CandidateService.getCandidateData();

    if (mounted) {
      setState(() {
        candidateData = data;
      });
    }
  }

  void _showRateCompanyBottomSheet(BuildContext context) {
    int selectedRating = 0;
    Company? selectedCompany;
    String? selectedDesignation;
    bool currentlyWorkHere = false;
    final String? profileImage = candidateData?['profilePicture'];

    final reviewController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.90,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Drag handle
                    const SizedBox(height: 16),

                    Container(
                      width: 135,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xff4B4F5C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xffEEF5FF),
                        border: Border(
                          top: BorderSide(color: Color(0xffDCE7FF)),
                          bottom: BorderSide(color: Color(0xffDCE7FF)),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                                (profileImage != null &&
                                    profileImage.isNotEmpty)
                                ? NetworkImage(profileImage)
                                : null,
                            child:
                                (profileImage == null || profileImage.isEmpty)
                                ? const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),

                          const SizedBox(width: 20),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${candidateData?['firstname'] ?? ''} ${candidateData?['lastname'] ?? ''}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(5, (index) {
                                final rating = index + 1;

                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      selectedRating = rating;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Icon(
                                        rating <= selectedRating
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 54,
                                        color: const Color(0xffFBC238),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        _ratingText(rating),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 30),

                            const Text(
                              "Company Name",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<Company>(
                                  value: selectedCompany,
                                  decoration: InputDecoration(
                                    hintText: "Choose Company",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: companies.map((company) {
                                    return DropdownMenuItem<Company>(
                                      value: company,
                                      child: Text(company.companyName),
                                    );
                                  }).toList(),
                                  onChanged: (company) {
                                    setModalState(() {
                                      selectedCompany = company;
                                    });
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            const Text(
                              "Your Designation",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 10),

                            DropdownButtonFormField<String>(
                              initialValue: selectedDesignation,
                              decoration: InputDecoration(
                                hintText: "Choose your designation",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items:
                                  const [
                                    "Flutter Developer",
                                    "Software Engineer",
                                    "Senior Software Engineer",
                                    "Product Manager",
                                    "UI/UX Designer",
                                    "QA Engineer",
                                    "Other",
                                  ].map((designation) {
                                    return DropdownMenuItem<String>(
                                      value: designation,
                                      child: Text(designation),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setModalState(() {
                                  selectedDesignation = value;
                                });
                              },
                            ),
                            if (selectedDesignation == "Other") ...[
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: otherDesignationController,
                                decoration: InputDecoration(
                                  hintText: "Enter your designation",
                                  labelText: "Designation",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 6),

                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: currentlyWorkHere,
                              title: const Text(
                                "I Currently Work Here",
                                style: TextStyle(fontSize: 14),
                              ),
                              onChanged: (value) {
                                setModalState(() {
                                  currentlyWorkHere = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              "Your Review",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            const SizedBox(height: 10),

                            TextField(
                              controller: reviewController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "Write your detailed review",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),
                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: ElevatedButton(
                                onPressed: isPostingReview
                                    ? null
                                    : () async {
                                        if (selectedRating == 0 ||
                                            selectedCompany == null ||
                                            selectedDesignation == null ||
                                            reviewController.text
                                                .trim()
                                                .isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please fill all required fields",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        setModalState(() {
                                          isPostingReview = true;
                                        });
                                        final result =
                                            await CompanyReviewService.postReview(
                                              companyId: selectedCompany!.id
                                                  ,
                                              rating: selectedRating,
                                              title: _ratingText(
                                                selectedRating,
                                              ),
                                              content: reviewController.text
                                                  .trim(),
                                              pros: "",
                                              cons: "",
                                            );
                                        debugPrint("Button clicked");
                                        debugPrint(
                                          "Company: ${selectedCompany?.id}",
                                        );
                                        debugPrint("Rating: $selectedRating");
                                        debugPrint(
                                          "Designation: $selectedDesignation",
                                        );
                                        debugPrint(
                                          "Review: ${reviewController.text}",
                                        );

                                        if (!mounted) return;

                                        setModalState(() {
                                          isPostingReview = false;
                                        });
                                        if (result.success) {
                                          Get.snackbar(
                                            "Sucess",
                                            "Review posted successfully",
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            margin: const EdgeInsets.all(12),
                                            borderRadius: 10,
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                          );

                                          Navigator.pop(context);

                                          loadCompanies();
                                        }
                                        Get.snackbar(
                                          "Error",
                                          result.message,
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red.shade600,
                                          colorText: Colors.white,
                                          icon: const Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          margin: const EdgeInsets.all(12),
                                          borderRadius: 12,
                                          snackStyle: SnackStyle.FLOATING,
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff8DB5F5),
                                  disabledBackgroundColor: const Color(
                                    0xff8DB5F5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isPostingReview
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Text(
                                        "Post Review",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _ratingText(int rating) {
    switch (rating) {
      case 1:
        return "Terrible";
      case 2:
        return "Bad";
      case 3:
        return "Okay";
      case 4:
        return "Good";
      case 5:
        return "Great";
      default:
        return "";
    }
  }

  Future<void> loadCompanies() async {
    setState(() {
      isLoading = true;
    });

    final data = await CompanyService.getCompanies();

    if (!mounted) return;

    setState(() {
      companies = data;
      filteredCompanies = data;
      isLoading = false;
    });
  }

  void searchCompanies() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredCompanies = companies.where((company) {
        return company.companyName.toLowerCase().contains(query) ||
            company.address.state.toLowerCase().contains(query) ||
            company.address.district.toLowerCase().contains(query) ||
            company.industries.join(",").toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),

      body: RefreshIndicator(
        onRefresh: loadCompanies,
        child: CustomScrollView(
          slivers: [
            _buildHeader(),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 18),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Company Spotlight",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        _showRateCompanyBottomSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [Color(0xff4D7CFE), Color(0xffD933FF)],
                          ),
                        ),
                        child: const Text(
                          "Rate Your Company",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (filteredCompanies.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    "No Companies Found",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final company = filteredCompanies[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(18),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CompanyDetailsScreen(companyId: company.id),
                          ),
                        );
                      },

                      child: Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(18),

                          border: Border.all(color: const Color(0xffDCE7FF)),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,

                                  backgroundColor: Colors.grey.shade200,

                                  backgroundImage:
                                      company.companyLogo.isNotEmpty
                                      ? NetworkImage(company.companyLogo)
                                      : null,

                                  child: company.companyLogo.isEmpty
                                      ? const Icon(Icons.business)
                                      : null,
                                ),

                                const Spacer(),

                                Row(
                                  children: List.generate(
                                    company.trustBadge.stars,

                                    (_) => const Padding(
                                      padding: EdgeInsets.only(left: 2),

                                      child: Icon(
                                        Icons.star,

                                        size: 14,

                                        color: Color(0xffF59E0B),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Text(
                              company.companyName,

                              maxLines: 2,

                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontWeight: FontWeight.w700,

                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 5),

                            // Text(
                            //   company.industries.join(", "),

                            //   maxLines: 2,

                            //   overflow: TextOverflow.ellipsis,

                            //   style: const TextStyle(color: Colors.grey),
                            // ),

                            // const SizedBox(height: 10),
                            const Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${company.totalReviews} Reviews",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffEEF5FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${company.trustScore}",
                                    style: const TextStyle(
                                      color: Color(0xff1E6BE3),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              company.companySize,
                              style: const TextStyle(
                                color: Color(0xff76A8FF),
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: filteredCompanies.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: .78,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
          top: 68,
          left: 24,
          right: 24,
          bottom: 42,
        ),
        decoration: const BoxDecoration(
          color: Color(0xff1E6BE3),
          image: DecorationImage(
            image: AssetImage("assets/Head.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                children: [
                  TextSpan(text: "Your "),
                  TextSpan(
                    text: "journey",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  TextSpan(text: " to great\nworkplaces starts here"),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Browse trusted companies, read insights, and\nchoose where you'll thrive.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search companies...",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
