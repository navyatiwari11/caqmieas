import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

class ViewInsightsScreen extends StatefulWidget {
  final String stationId;
  const ViewInsightsScreen({Key? key, required this.stationId}) : super(key: key);

  @override
  State<ViewInsightsScreen> createState() => _ViewInsightsScreenState();
}

class _ViewInsightsScreenState extends State<ViewInsightsScreen> {
  DateTime selectedDate = DateTime.now();

  final GlobalKey aqiKey = GlobalKey();
  final GlobalKey pm25Key = GlobalKey();
  final GlobalKey pm10Key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E4),
      appBar: AppBar(
        title: Text(
          'Insights',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF061090),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: $formattedDate',
                      style: GoogleFonts.outfit(fontSize: 14, color: Colors.black87),
                    ),
                    const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('aqi_hourly')
                  .where('device_id', isEqualTo: widget.stationId)
                  .where('date', isEqualTo: formattedDate)
                  .orderBy('hour')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('Error loading data'));
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                final docs = snapshot.data!.docs;

                List<FlSpot> aqiSpots = [];
                List<BarChartGroupData> pm25Bars = [];
                List<BarChartGroupData> pm10Bars = [];
                List<String> xLabels = [];

                double minAQI = double.infinity, maxAQI = double.negativeInfinity;
                double minPM25 = double.infinity, maxPM25 = double.negativeInfinity;
                double minPM10 = double.infinity, maxPM10 = double.negativeInfinity;

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;

                  final hour = data['hour'] ?? 0;
                  final aqi = (data['avg_aqi'] as num?)?.toDouble();
                  final pm25 = (data['avg_pm25'] as num?)?.toDouble();
                  final pm10 = (data['avg_pm10'] as num?)?.toDouble();

                  if (aqi == null || pm25 == null || pm10 == null) continue;

                  maxAQI = aqi > maxAQI ? aqi : maxAQI;
                  minAQI = aqi < minAQI ? aqi : minAQI;
                  maxPM25 = pm25 > maxPM25 ? pm25 : maxPM25;
                  maxPM10 = pm10 > maxPM10 ? pm10 : maxPM10;

                  aqiSpots.add(FlSpot(hour.toDouble(), aqi));
                  pm25Bars.add(BarChartGroupData(x: hour, barRods: [
                    BarChartRodData(toY: pm25, color: const Color(0xFFFCB47A), width: 16, borderRadius: BorderRadius.zero,)
                  ]));
                  pm10Bars.add(BarChartGroupData(x: hour, barRods: [
                    BarChartRodData(toY: pm10, color: const Color(0xFFCC7E85), width: 16, borderRadius: BorderRadius.zero,)
                  ]));
                  xLabels.add(hour.toString());
                }

                double aqiMin = (minAQI == double.infinity || maxAQI == double.negativeInfinity) ? 0 : minAQI;
                double aqiMax = maxAQI == double.negativeInfinity ? 100 : maxAQI;

                double pm25Min = (minPM25 == double.infinity || maxPM25 == double.negativeInfinity) ? 0 : minPM25;
                double pm25Max = maxPM25 == double.negativeInfinity ? 100 : maxPM25;

                double pm10Min = (minPM10 == double.infinity || maxPM10 == double.negativeInfinity) ? 0 : minPM10;
                double pm10Max = maxPM10 == double.negativeInfinity ? 100 : maxPM10;

                // Define Y-axis ranges and intervals
                double aqiMinY = 0, aqiMaxY = 200, aqiInterval = 15;
                double pm25MinY = 0, pm25MaxY = 120, pm25Interval = 30;
                double pm10MinY = 0, pm10MaxY = 300, pm10Interval = 30;

                // Dynamic chart heights based on label count × step height
                double perStepHeight = 20;
                double aqiChartHeight = calculateChartHeight(aqiMinY, aqiMaxY, aqiInterval, perStepHeight);
                double pm25ChartHeight = calculateChartHeight(pm25MinY, pm25MaxY, pm25Interval, perStepHeight);
                double pm10ChartHeight = calculateChartHeight(pm10MinY, pm10MaxY, pm10Interval, perStepHeight);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      buildChartContainer(
                        "AQI",
                        0, 400, 20, 30, //minY, maxY, interval, perStepHeight
                        buildLineChart(
                          aqiSpots,
                          const Color(0xFF4E8D7C),
                          xLabels,
                          0, 400, 20, 1, //minY, maxY, yInterval, xInterval
                        ),
                        aqiKey,
                      ),
                      buildChartContainer(
                        "PM2.5 (μg/m³)",
                        0,120,12,30,
                         buildBarChart(
                          barData: pm25Bars,
                          color: const Color(0xFFFCB47A),
                          xLabels: xLabels,
                          minY: 0,
                          maxY: 120,
                          horizontalInterval: 12,
                          verticalInterval: 1,
                        ),
                        pm25Key,
                      ),
                      
                      buildChartContainer(
                        "PM10 (μg/m³)",
                        0,300,30,30,
                        buildBarChart(
                          barData: pm10Bars,
                          color: const Color(0xFFCC7E85),
                          xLabels: xLabels,
                          minY: pm10MinY,
                          maxY: pm10MaxY,
                          horizontalInterval: 30,
                          verticalInterval: 1,
                        ),
                        pm10Key,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChartContainer(
    String title,
    double minY,
    double maxY,
    double interval,
    double perStepHeight,
    Widget chart,
    GlobalKey chartKey,
  ) {
    double chartHeight = calculateChartHeight(minY, maxY, interval, perStepHeight);
    double totalHeight = chartHeight+30;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 40.0 * 24,
                height: chartHeight,
                child: chart,
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget buildBarChart({
    required List<BarChartGroupData> barData,
    required Color color,
    required List<String> xLabels,
    required double minY,
    required double maxY,
    required double horizontalInterval,
    required double verticalInterval,
  }) {
    return BarChart(
      BarChartData(
        minY: minY,
        maxY: maxY,
        alignment: BarChartAlignment.spaceAround,
        barGroups: barData,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => _buildTitles(value, xLabels),
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: horizontalInterval,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: TextStyle(fontSize: 10, color: Colors.black87),
              ),
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval: horizontalInterval,
          verticalInterval: verticalInterval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          ),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${xLabels[group.x]} hr : ${rod.toY.toStringAsFixed(1)} μg/m³',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),
        ),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  Widget buildLineChart(
    List<FlSpot> dataPoints,
    Color color,
    List<String> xLabels,
    double minY,
    double maxY,
    double yInterval,
    double xInterval,
  ) {
    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints,
            isCurved: true,
            barWidth: 3,
            color: color,
            dotData: FlDotData(show: true),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => _buildTitles(value, xLabels),
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: yInterval,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: TextStyle(fontSize: 10, color: Colors.black87),
              ),
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval: yInterval,
          verticalInterval: xInterval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${xLabels[spot.x.toInt()]} hr : ${spot.y.toStringAsFixed(1)}',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  Widget _buildTitles(double value, List<String> labels) {
    int index = value.toInt();
    if (index < 0 || index >= labels.length) return const SizedBox();
    return Text(labels[index], style: const TextStyle(fontSize: 10));
  }
}
double calculateChartHeight(double min, double max, double interval, double perStepHeight) {
  double steps = ((max - min) / interval).ceil().toDouble();
  return steps * perStepHeight;
}