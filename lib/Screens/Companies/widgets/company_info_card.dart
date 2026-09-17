import 'package:flutter/material.dart';
import 'package:zuperr/Models/CompanyById.dart';

class CompanyInfoCard extends StatelessWidget {
  final CompanyById company;

  const CompanyInfoCard({
    super.key,
    required this.company,
  });

  static const Color titleColor = Color(0xff2C3141);
  static const Color subtitleColor = Color(0xff72798A);
  static const Color dividerColor = Color(0xffEDF1F6);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 26, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                height: 86,
                width: 86,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xffE8EDF5),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: company.companyLogo.isEmpty
                      ? const Icon(
                          Icons.business,
                          size: 42,
                          color: Color(0xff1E6BE3),
                        )
                      : Image.network(
                          company.companyLogo,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) {
                            return const Icon(
                              Icons.business,
                              size: 42,
                              color: Color(0xff1E6BE3),
                            );
                          },
                        ),
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        company.companyName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        company.description.isEmpty
                            ? "No company description"
                            : company.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.45,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 34),

          /// GRID
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: dividerColor,
                ),
                bottom: BorderSide(
                  color: dividerColor,
                ),
              ),
            ),
            child: Column(
              children: [

                Row(
                  children: [

                    Expanded(
                      child: _item(
                        "Company Size",
                        company.companySize.isEmpty
                            ? "N/A"
                            : company.companySize,
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 108,
                      color: dividerColor,
                    ),

                    Expanded(
                      child: _item(
                        "Year of establishment",
                        company.createdAt.year.toString(),
                      ),
                    ),
                  ],
                ),

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: dividerColor,
                ),

                Row(
                  children: [

                    Expanded(
                      child: _item(
                        "Industry",
                        company.industries.isEmpty
                            ? "N/A"
                            : company.industries.first,
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 108,
                      color: dividerColor,
                    ),

                    Expanded(
                      child: _item(
                        "HQ Location",
                        "${company.address.district}, ${company.address.state}",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    String title,
    String value,
  ) {
    return SizedBox(
      height: 108,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: subtitleColor,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: titleColor,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}