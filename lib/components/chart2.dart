import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../../provider/data_provider.dart';

class MyPieChart2 extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  MyPieChart2({required this.startDate, required this.endDate});

  @override
  _MyPieChart2State createState() => _MyPieChart2State();
}

class _MyPieChart2State extends State<MyPieChart2> {
  Future<Map<String, double>>? _dataMapFuture;

  @override
  void initState() {
    super.initState();
    DataProvider providerCommunity =
        Provider.of<DataProvider>(context, listen: false);
    _dataMapFuture = fetchData(providerCommunity);
  }

  @override
  void didUpdateWidget(MyPieChart2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      setState(() {
        DataProvider providerCommunity =
            Provider.of<DataProvider>(context, listen: false);
        _dataMapFuture = fetchData(providerCommunity);
      });
    }
  }

  Future<Map<String, double>> fetchData(DataProvider providerCommunity) async {
    // Fetch data from database and return it as a Map<String, double>
    return await providerCommunity.pieChartDataOfCommunities2(
      widget.startDate,
      widget.endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _dataMapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner while waiting for data to load
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Build the PieChart widget once data has been loaded
          return PieChart(
            dataMap: snapshot.data!,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32.0,
            chartRadius: MediaQuery.of(context).size.width / 2.7,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          );
        } else {
          // Handle the case where no data has been fetched
          return Text('No data available');
        }
      },
    );
  }
}
