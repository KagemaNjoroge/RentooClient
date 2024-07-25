import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rentoo_pms/components/common/gap.dart';

class RentCollectionChart extends StatelessWidget {
  const RentCollectionChart({super.key, required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      isShowingMainData ? sampleData1 : sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  BarChartData get sampleData1 => BarChartData(
        barTouchData: barTouchData1,
        titlesData: titlesData1,
        borderData: borderData,
        barGroups: barGroups1,
        gridData: const FlGridData(show: false),
      );

  BarChartData get sampleData2 => BarChartData(
        barTouchData: barTouchData2,
        titlesData: titlesData2,
        borderData: borderData,
        barGroups: barGroups2,
        gridData: const FlGridData(show: false),
      );

  BarTouchData get barTouchData1 => BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) {
            return Colors.transparent;
          },
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String month;
            switch (group.x.toInt()) {
              case 0:
                month = 'JAN';
                break;
              case 1:
                month = 'FEB';
                break;
              case 2:
                month = 'MAR';
                break;
              case 3:
                month = 'APR';
                break;
              case 4:
                month = 'MAY';
                break;
              case 5:
                month = 'JUN';
                break;
              case 6:
                month = 'JUL';
                break;
              case 7:
                month = 'AUG';
                break;
              case 8:
                month = 'SEP';
                break;
              case 9:
                month = 'OCT';
                break;
              case 10:
                month = 'NOV';
                break;
              case 11:
                month = 'DEC';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$month\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY).toString(),
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, BarTouchResponse? touchResponse) {},
      );

  BarTouchData get barTouchData2 => BarTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1k';
        break;
      case 2:
        text = '2k';
        break;
      case 3:
        text = '3k';
        break;
      case 4:
        text = '4k';
        break;
      case 5:
        text = '5k';
        break;
      case 6:
        text = '6k';
        break;
      case 7:
        text = '7k';
        break;
      case 8:
        text = '8k';
        break;
      case 9:
        text = '9k';
        break;
      case 10:
        text = '10k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('JAN', style: style);
        break;
      case 1:
        text = const Text('FEB', style: style);
        break;
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 3:
        text = const Text('APR', style: style);
        break;
      case 4:
        text = const Text('MAY', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 6:
        text = const Text('JUL', style: style);
        break;
      case 7:
        text = const Text('AUG', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      case 9:
        text = const Text('OCT', style: style);
        break;
      case 10:
        text = const Text('NOV', style: style);
        break;
      case 11:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border.all(
          color: Colors.transparent,
          width: 1,
        ),
      );

  List<BarChartGroupData> get barGroups1 => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 5,
              color: Colors.blue,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 6,
              color: Colors.pink,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 7,
              color: Colors.cyan,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: 8,
              color: Colors.blue,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: 5,
              color: Colors.pink,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: 6,
              color: Colors.cyan,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: 7,
              color: Colors.blue,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 7,
          barRods: [
            BarChartRodData(
              toY: 8,
              color: Colors.pink,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(
              toY: 5,
              color: Colors.cyan,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 9,
          barRods: [
            BarChartRodData(
              toY: 6,
              color: Colors.blue,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 10,
          barRods: [
            BarChartRodData(
              toY: 7,
              color: Colors.pink,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 11,
          barRods: [
            BarChartRodData(
              toY: 8,
              color: Colors.cyan,
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      ];

  List<BarChartGroupData> get barGroups2 => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 6,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 7,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 8,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: 5,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: 6,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: 7,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: 8,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 7,
          barRods: [
            BarChartRodData(
              toY: 5,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(
              toY: 6,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 9,
          barRods: [
            BarChartRodData(
              toY: 7,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 10,
          barRods: [
            BarChartRodData(
              toY: 8,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 11,
          barRods: [
            BarChartRodData(
              toY: 5,
              color: Colors.red.withOpacity(0.5),
              width: 20,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}

class RentCollectionChartSample extends StatefulWidget {
  const RentCollectionChartSample({super.key});

  @override
  State<StatefulWidget> createState() => RentCollectionChartSampleState();
}

class RentCollectionChartSampleState extends State<RentCollectionChartSample> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Monthly Rent Collection',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(),
              const Gap(),
              const Gap(),
              const Gap(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6, top: 20),
                  child:
                      RentCollectionChart(isShowingMainData: isShowingMainData),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                color:
                    Colors.blueGrey.withOpacity(isShowingMainData ? 1.0 : 0.5),
              ),
              onPressed: () {
                setState(() {
                  isShowingMainData = !isShowingMainData;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
