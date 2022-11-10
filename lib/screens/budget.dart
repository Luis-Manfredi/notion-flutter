import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notion_test/client/budget_repo.dart';
import 'package:notion_test/components/spending_chart.dart';
import 'package:notion_test/constants/colors.dart';
import 'package:notion_test/models/failure_model.dart';
import 'package:notion_test/models/item_model.dart';

class Budget extends StatefulWidget {
  const Budget({super.key});

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = BudgetRepository().getItems();
  }

  Future refreshScreen() async {
    _futureItems = BudgetRepository().getItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: primary,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Presupuestos', style: TextStyle(color: text, fontSize: 24)),
            ],
          ),
          const SizedBox(width: 20)
        ],
      ),

      body: RefreshIndicator(
        color: primary,
        onRefresh: refreshScreen,
        child: FutureBuilder<List<Item>>(
          future: _futureItems,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return SpendingChart(items: items);
                  final item = items[index - 1];
        
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 4,
                        color: getBorderColor(item.category)
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6
                        )
                      ]
                    ),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('${item.category} - ${DateFormat.yMd().format(item.date)}'),
                      trailing: Text('-\$${item.price}', style: const TextStyle(fontSize: 18)),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              final failure = snapshot.error as Failure;
              return Center(child: Text(failure.message, style: const TextStyle(fontSize: 24, color: text)));
            }
            
            return const Center(child: CircularProgressIndicator(color: primary));
          },
        ),
      ),
    );
  }

  Color getBorderColor(String category) {
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