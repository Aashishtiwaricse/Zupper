import 'package:flutter/material.dart';
import 'package:zuperr/Models/CompanyById.dart';
import 'package:zuperr/Screens/Companies/widgets/RatingsReviewsCard.dart';
import 'package:zuperr/Screens/Companies/widgets/aboutCompany.dart';
import 'package:zuperr/Services/Company/getCompaniesById.dart';
import 'widgets/company_header.dart';
import 'widgets/company_info_card.dart';
import 'widgets/posted_jobs_section.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final String companyId;

  const CompanyDetailsScreen({
    super.key,
    required this.companyId,
  });

  @override
  State<CompanyDetailsScreen> createState() =>
      _CompanyDetailsScreenState();
}
class _CompanyDetailsScreenState
    extends State<CompanyDetailsScreen> {
  CompanyById? company;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    fetchCompanyById();
  }

  Future<void> fetchCompanyById() async {
    try {
      final result =
          await CompanyByIdService.getCompanyById(
        widget.companyId,
      );

      if (!mounted) return;

      setState(() {
        company = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (company == null) {
      return Scaffold(
        body: Center(
          child: Text(
            errorMessage ?? "Company not found",
          ),
        ),
      );
    }

    final currentCompany = company!;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: CompanyHeader(
              company: currentCompany,
            ),
          ),

          SliverToBoxAdapter(
            child: CompanyInfoCard(
              company: currentCompany,
            ),
          ),

          SliverToBoxAdapter(
            child: AboutCompany(
              company: currentCompany,
            ),
          ),

          SliverToBoxAdapter(
            child: PostedJobsSection(
              company: currentCompany,
            ),
          ),

       
//           SliverToBoxAdapter(
//   child: TrustScoreCard(
//     company: currentCompany,
//   ),
// ),
          SliverToBoxAdapter(
  child: RatingsReviewsCard(
    company: currentCompany,
  ),
),

          
        ],
      ),
    );
  }
}