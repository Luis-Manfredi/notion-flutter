import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:notion_test/components/indicator.dart';
import 'package:notion_test/constants/colors.dart';
import 'package:notion_test/models/item_model.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key, required this.items});

  final List<Item> items;

  @override
  Widget build(BuildContext context) {

    final spending = <String, double>{};

    items.forEach(
      (item) => spending.update(
        item.category, (value) => value + double.parse(item.price),
        ifAbsent: () => double.parse(item.price),
      )
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 400.0,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Text('Gráfico de Gastos', style: TextStyle(fontSize: 24), textAlign: TextAlign.left,)
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: spending.map(
                    (category, amount) => MapEntry(
                      category, PieChartSectionData(
                        color: getCategoryColor(category),
                        radius: 100.0, 
                        title: '\$${amount.toStringAsFixed(1)}',
                        titleStyle: const TextStyle(color: text, fontSize: 12),
                        value: amount
                      )
                    )
                  ).values.toList(),
                  sectionsSpace: 0
                )
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: spending.keys.map(
                (category) => Indicator(
                  color: getCategoryColor(category),
                  text: category
                )
              ).toList()
            )
          ],
        ),
      ),
    );
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Marketing':
        return const Color(0xFF966262);
      case 'Comida':
        return const Color.fromARGB(255, 32, 126, 170);
      case 'Tecnologías':
        return const Color.fromARGB(255, 58, 143, 81);
      case 'Studio':
        return const Color.fromARGB(255, 245, 201, 3);
      case 'Transporte':
        return const Color.fromARGB(255, 180, 47, 201);
      default:
        return const Color.fromARGB(255, 156, 156, 156); 
    }
  }
}