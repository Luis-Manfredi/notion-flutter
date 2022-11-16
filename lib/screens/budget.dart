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
  final _formKey = GlobalKey<FormState>();
  late Future<List<Item>> _futureItems;
  String? categoryValue; 
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioController = TextEditingController();

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

    void addDialog () => showDialog(
      context: context, 
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Añadir Nueva Entrada'),
              Row(
                children: [
                  CloseButton(
                    onPressed: () {
                      categoryValue = null;
                      Navigator.pop(context);
                    }, 
                    color: Colors.black45
                  ), 
                  const SizedBox(width: 10),
                ],
              ) 
            ],
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 15, 0, 20),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      label: const Text('Nombre', style: TextStyle(color: primary)),
                      hintText: 'Añadir un nombre',
                      hintStyle: const TextStyle(color: Colors.black45),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2, color: Colors.black45)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2, color: primary)
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2, color: Color(0xFFC62828))
                      )
                    ),
                    validator: (value) => value!.isEmpty || value.contains(RegExp(r'(\d+)')) ? 'Ingrese un nombre' : null
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: precioController,
                    decoration: InputDecoration(
                      label: const Text('Precio', style: TextStyle(color: primary)),
                      hintText: 'Añadir un precio',
                      hintStyle: const TextStyle(color: Colors.black45),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2, color: Colors.black45)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2, color: primary)
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2, color: Color(0xFFC62828))
                      )
                    ),
                    validator: (value) => value!.isEmpty || !value.contains(RegExp(r'(\d+)')) ? 'Ingrese un número' : null
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField(
                    borderRadius: BorderRadius.circular(10),
                    value: categoryValue,
                    isExpanded: true,
                    iconEnabledColor: primary,
                    hint: const Text('Elegir una categoría'),
                    items: const [
                      DropdownMenuItem(
                        value: 'Marketing',
                        child: Text('Marketing'),
                      ),
                      DropdownMenuItem(
                        value: 'Tecnologías',
                        child: Text('Tecnologías'),
                      ),
                      DropdownMenuItem(
                        value: 'Comida',
                        child: Text('Comida'),
                      ),
                      DropdownMenuItem(
                        value: 'Studio',
                        child: Text('Studio'),
                      ),
                      DropdownMenuItem(
                        value: 'Transporte',
                        child: Text('Transporte'),
                      ),
                      DropdownMenuItem(
                        value: 'Varios',
                        child: Text('Varios'),
                      )
                    ], 
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2, color: Color(0xFFC62828))
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2, color: Colors.black45)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2, color: primary)
                      )
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        categoryValue = value ?? 'Elegir una categoría';
                      });
                    },
                    validator: (value) => value == null ? 'Elegir un valor' : null
                  )
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
              onPressed: () {
                categoryValue = null;
                Navigator.pop(context);
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFdcdcdc),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(120, 45)
              ),
              child: const Text('Cancelar', style: TextStyle(color: primary, fontSize: 18))
            ),

            ElevatedButton(
              onPressed: () { 
                final isValid = _formKey.currentState!.validate();
                if (isValid) {
                  BudgetRepository().createItem(
                    nombreController.text, 
                    categoryValue!, 
                    double.tryParse(precioController.text)!, 
                    DateTime.now()
                  );

                  nombreController.clear();
                  precioController.clear();
                  categoryValue = null;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Se ha creado el elemento en la base de datos. Actualice la vista para ver los resultados.',
                          style: TextStyle(color: text),
                        ),
                        duration: Duration(seconds: 5),
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                          )
                        ),
                      )
                    );
                }
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(120, 45)
              ),
              child: const Text('Añadir', style: TextStyle(color: text, fontSize: 18))
            )
          ],
        ),
      ),
    );

    void editDialog (String id, String nombre, String precio, String categoria) => showDialog(
      context: context, 
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {

          TextEditingController updateNameController = TextEditingController(text: nombre);
          TextEditingController updatePriceController = TextEditingController(text: precio.toString());
          String? itemCategory = categoria;

          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Editar Entrada'),
                Row(
                  children: [
                    CloseButton(
                      onPressed: () {
                        categoryValue = null;
                        Navigator.pop(context);
                      }, 
                      color: Colors.black45
                    ),
                    const SizedBox(width: 10),
                  ],
                )
              ],
            ),
            titlePadding: const EdgeInsets.fromLTRB(20, 15, 0, 20),
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: updateNameController,
                      decoration: InputDecoration(
                        label: const Text('Nombre', style: TextStyle(color: primary)),
                        hintText: 'Añadir un nombre',
                        hintStyle: const TextStyle(color: Colors.black45),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 2, color: Colors.black45)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 2, color: primary)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 2, color: Color(0xFFC62828))
                        )
                      ),
                      validator: (value) => value!.isEmpty || value.contains(RegExp(r'(\d+)')) ? 'Ingrese un nombre' : null
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: updatePriceController,
                      decoration: InputDecoration(
                        label: const Text('Precio', style: TextStyle(color: primary)),
                        hintText: 'Añadir un precio',
                        hintStyle: const TextStyle(color: Colors.black45),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 2, color: Colors.black45)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 2, color: primary)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 2, color: Color(0xFFC62828))
                        )
                      ),
                      validator: (value) => value!.isEmpty || !value.contains(RegExp(r'(\d+)')) ? 'Ingrese un número' : null
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField(
                      borderRadius: BorderRadius.circular(10),
                      value: itemCategory,
                      isExpanded: true,
                      iconEnabledColor: primary,
                      hint: const Text('Elegir una categoría'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Marketing',
                          child: Text('Marketing'),
                        ),
                        DropdownMenuItem(
                          value: 'Tecnologías',
                          child: Text('Tecnologías'),
                        ),
                        DropdownMenuItem(
                          value: 'Comida',
                          child: Text('Comida'),
                        ),
                        DropdownMenuItem(
                          value: 'Studio',
                          child: Text('Studio'),
                        ),
                        DropdownMenuItem(
                          value: 'Transporte',
                          child: Text('Transporte'),
                        ),
                        DropdownMenuItem(
                          value: 'Varios',
                          child: Text('Varios'),
                        )
                      ], 
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 2, color: Color(0xFFC62828))
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 2, color: Colors.black45)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 2, color: primary)
                        )
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          itemCategory = value ?? 'Elegir una categoría';
                        });
                      },
                      validator: (value) => value == null ? 'Elegir un valor' : null
                    )
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              ElevatedButton(
                onPressed: () {
                  categoryValue = null;
                  Navigator.pop(context);
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFdcdcdc),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(120, 45)
                ),
                child: const Text('Cancelar', style: TextStyle(color: primary, fontSize: 18))
              ),

              ElevatedButton(
                onPressed: () { 
                  final isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    BudgetRepository().updateItem(
                      id,
                      updateNameController.text, 
                      double.parse(updatePriceController.text), 
                      itemCategory!, 
                    );

                    updateNameController.clear();
                    updatePriceController.clear();
                    itemCategory = null;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Se ha modificado el elemento. Actualice la vista para ver los resultados.',
                          style: TextStyle(color: text),
                        ),
                        duration: Duration(seconds: 5),
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                          )
                        ),
                      )
                    );
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(120, 45)
                ),
                child: const Text('Actualizar', style: TextStyle(color: text, fontSize: 18))
              )
            ]
          );
        }
      )
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 80),
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
                      onTap: () {
                        editDialog(item.id, item.name, item.price, item.category);
                      },
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

      floatingActionButton: FloatingActionButton(
        onPressed: () => addDialog(),
        backgroundColor: primary,
        child: const Icon(Icons.add, color: text, size: 36),
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