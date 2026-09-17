import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuperr/Models/EmployeStats/employee_stats_model.dart';
import 'package:zuperr/Services/profileUpdateData/employee_stats_service.dart';


class Analytics extends StatefulWidget {
  const Analytics({super.key});


@override

AnalyticsState createState() => AnalyticsState();

}
class AnalyticsState extends State<Analytics> {
  int selectedDays = 7;
  bool isLoading = true;

  EmployeeStatsModel? statsModel;

  @override
void initState() {
  super.initState();
  refreshData();
}


  Future<void> refreshData() async {
  setState(() {
    isLoading = true;
  });

  await getStats();

  if (!mounted) return;

  setState(() {
    isLoading = false;
  });
}

  Future<void> getStats() async {
    setState(() {
      isLoading = true;
    });

    statsModel = await EmployeeStatsService.getStats(selectedDays);

    setState(() {
      isLoading = false;
    });
  }

  int get totalApplications =>
    statsModel?.totals.jobsApplied ?? 0;

int get totalViews =>
    statsModel?.totals.jobsViewed ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FB),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : statsModel == null || statsModel!.data.isEmpty
         ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 15),
                Text(
                  "No Data Found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        /// HEADER
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xff009245).withValues(alpha: .1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.analytics_outlined,
                                color: Color(0xff009245),
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Profile Performance",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Track your profile engagement",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        /// FILTER
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border:
                                  Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: selectedDays,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: const [
                                  DropdownMenuItem(
                                      value: 7, child: Text("Last 7 Days")),
                                  DropdownMenuItem(
                                      value: 15, child: Text("Last 15 Days")),
                                  DropdownMenuItem(
                                      value: 30, child: Text("Last 30 Days")),
                                ],
                                onChanged: (value) async {
                                  if (value == null) return;

                                  setState(() {
                                    selectedDays = value;
                                  });

                                  await getStats();
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// SUMMARY
                        Row(
                          children: [
                            Expanded(
                              child: dashboardCard(
                                "Applications",
                                totalApplications.toString(),
                                Icons.work_outline,
                                const Color(0xff009245),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: dashboardCard(
                                "Views",
                                totalViews.toString(),
                                Icons.remove_red_eye_outlined,
                                Colors.orange,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        /// CHART CARD
                        Container(
  padding: const EdgeInsets.fromLTRB(18, 60, 18, 18),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .05),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Performance Chart",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              buildChart(),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 25,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: [
                                  buildLegend(
                                    const Color(0xff009245),
                                    "Applications",
                                  ),
                                  buildLegend(
                                    const Color(0xff9BE8BE),
                                    "Views",
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget dashboardCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: .12),
            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 20),

          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget buildLegend(Color color, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget buildChart() {
  final data = statsModel!.data;

  double maxValue = 0;

  for (var e in data) {
    maxValue = [
      maxValue,
      e.jobsApplied.toDouble(),
      e.jobsViewed.toDouble(),
    ].reduce((a, b) => a > b ? a : b);
  }

  // Add 20% space above highest bar
  double maxY = (maxValue * 1.2).ceilToDouble();

  // Make interval a clean number
  double interval;

  if (maxY <= 50) {
    interval = 10;
  } else if (maxY <= 100) {
    interval = 20;
  } else if (maxY <= 500) {
    interval = 50;
  } else {
    interval = 100;
  }


  double width = selectedDays == 7
      ? MediaQuery.of(context).size.width - 80
      : data.length * 55;


  return SizedBox(
    height: 360,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: width,
        child: BarChart(
          BarChartData(
            maxY: maxY,
            alignment: BarChartAlignment.spaceAround,

            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: interval,
            ),

            titlesData: FlTitlesData(

              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 40,
                  showTitles: true,
                  interval: interval,

                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                    );
                  },
                ),
              ),

              rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),

              topTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {

                    int index = value.toInt();

                    if(index >= data.length){
                      return const SizedBox();
                    }

                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        "${index + 1}D",
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            barGroups: List.generate(
              data.length,
              (index) {

                final item = data[index];

                return BarChartGroupData(
                  x: index,
                  barsSpace: 4,

                  barRods: [

                    BarChartRodData(
                      toY: item.jobsApplied.toDouble(),
                      width: 10,
                      color: const Color(0xff009245),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    BarChartRodData(
                      toY: item.jobsViewed.toDouble(),
                      width: 10,
                      color: const Color(0xff9BE8BE),
                      borderRadius: BorderRadius.circular(8),
                    ),

                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}}