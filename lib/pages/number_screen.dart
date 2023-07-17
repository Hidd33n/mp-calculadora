import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mpcalcu/pages/ui/drawer_screen.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({Key? key}) : super(key: key);

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<double> remainingAmounts = [];
  double totalAmount = 0.0;
  late CollectionReference _cuentasCollection;

  @override
  void initState() {
    super.initState();
    _cuentasCollection = FirebaseFirestore.instance.collection('cuentas');
    syncDataFromFirebase();
  }

  Future<void> syncDataFromFirebase() async {
    try {
      final snapshot = await _cuentasCollection.doc('cuentas').get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        List<dynamic>? remainingAmountList = data['remainingAmountList'];

        if (remainingAmountList != null) {
          setState(() {
            remainingAmounts = remainingAmountList
                .map<double>((value) => double.parse(value.toString()))
                .toList();

            if (remainingAmounts.isNotEmpty) {
              totalAmount = remainingAmounts.reduce((a, b) => a + b);
            } else {
              totalAmount = 0.0;
            }
          });
        }
      }
    } catch (e) {
      print('Error al leer los datos desde Firebase: $e');
    }
  }

  Future<void> syncDataToFirebase() async {
    try {
      await _cuentasCollection.doc('cuentas').set({
        'remainingAmountList':
            remainingAmounts.map<String>((value) => value.toString()).toList(),
      });
    } catch (e) {
      print('Error al guardar los datos en Firebase: $e');
    }
  }

  Future<void> _addRemainingAmount(double amount) async {
    setState(() {
      remainingAmounts.add(amount);
      totalAmount += amount;
    });

    await syncDataToFirebase();
  }

  Future<void> _deleteRemainingAmount(double amount) async {
    setState(() {
      remainingAmounts.remove(amount);
      totalAmount -= amount;
    });

    await syncDataToFirebase();
  }

  Future<void> _deleteAllRemainingAmounts() async {
    setState(() {
      remainingAmounts.clear();
      totalAmount = 0.0;
    });

    await syncDataToFirebase();
  }

  Widget buildDrawer() {
    return DrawerScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteAllRemainingAmounts();
            },
          ),
        ],
      ),
      drawer: buildDrawer(),
      body: Column(
        children: [
          if (remainingAmounts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No hay resultados disponibles',
                style: TextStyle(fontSize: 16.0),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: remainingAmounts.length,
                itemBuilder: (context, index) {
                  final amount = remainingAmounts[index];
                  return Dismissible(
                    key: Key(amount.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      _deleteRemainingAmount(amount);
                    },
                    child: ListTile(
                      title: Text('Dinero Restante:'),
                      subtitle: Text('\$${amount.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Total Sumado: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Agregar Monto'),
                content: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Monto'),
                  onChanged: (value) {
                    // Validar y habilitar/deshabilitar el botón de agregar
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Agregar'),
                    onPressed: () {
                      double amount =
                          double.parse('0.0'); // Obtener el valor del TextField
                      _addRemainingAmount(amount);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
