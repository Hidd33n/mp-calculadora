import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:ionicons/ionicons.dart';
import 'package:mpcalcu/pages/ui/drawer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _amountController = TextEditingController();
  //String _transactionType = 'Venta Online';
  bool _isOnlineSale = false;
  //bool _isPresenSale = false;
  List<int> _selectedInstallments = [];
  int? selectedValue;

  Future<void> saveDataToFirebase(
      String collection, String document, Map<String, dynamic> data) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection(collection).doc(document).set(data);
  }

  double calculateFees(
      double amount, bool isOnlineSale, List<int> selectedInstallments) {
    double fee = 0.0;
    for (int installment in selectedInstallments) {
      if (installment == 7) {
        fee += amount * 0.078; //Credito 1cuota
      } else if (installment == 8) {
        fee += amount * 0.078; //debito
      } else if (installment == 9) {
        fee += amount * 0.0; //efectivo
      }
    }

    for (int installment in selectedInstallments) {
      if (installment == 1) {
        fee += amount * 0.078; // 7,8% credito una sola cuota
      } else if (installment == 2) {
        fee += amount * 0.184; // 18,4 credito 3 cuotas
      } else if (installment == 3) {
        fee += amount * 0.078; // 7,8% debito
      } else if (installment == 4) {
        fee += amount * 0.05; //5% transferencia
      }
    }

    return fee;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Widget buildDrawer() {
    return DrawerScreen(); // Reemplaza "DrawerScreen" con el nombre correcto de tu widget en drawer_screen.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      drawer: buildDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Monto de la venta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pago Online',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pago Presencial',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      SizedBox(
                        height: 30,
                      ),
                      CheckboxListTile(
                        title: Text('Credito 1 cuotas'),
                        value: _selectedInstallments.contains(1),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selectedInstallments = [1];
                            } else {
                              _selectedInstallments = [];
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text('Credito 3 cuotas'),
                        value: _selectedInstallments.contains(2),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selectedInstallments = [2];
                            } else {
                              _selectedInstallments = [];
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text('Debito'),
                        value: _selectedInstallments.contains(3),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selectedInstallments = [3];
                            } else {
                              _selectedInstallments = [];
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text('Transferencia'),
                        value: _selectedInstallments.contains(4),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selectedInstallments = [4];
                            } else {
                              _selectedInstallments = [];
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      CheckboxListTile(
                        title: Text('Credito 1Cuota'),
                        value: _selectedInstallments.contains(7),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selectedInstallments = [7];
                            } else {
                              _selectedInstallments = [];
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text('Debito'),
                        value: _selectedInstallments.contains(8),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selectedInstallments = [8];
                            } else {
                              _selectedInstallments = [];
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text('Efectivo'),
                        value: _selectedInstallments.contains(9),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selectedInstallments = [9];
                            } else {
                              _selectedInstallments = [];
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                double amount = double.tryParse(_amountController.text) ?? 0;
                double fees =
                    calculateFees(amount, _isOnlineSale, _selectedInstallments);
                double remainingAmount = amount - fees;

                // Obtener la lista actual de Firebase Firestore
                final firestore = FirebaseFirestore.instance;
                final collection = 'cuentas';
                final document = 'cuentas';
                DocumentSnapshot snapshot =
                    await firestore.collection(collection).doc(document).get();
                Map<String, dynamic>? data =
                    snapshot.data() as Map<String, dynamic>?;

                if (data != null) {
                  List<dynamic>? remainingAmountList =
                      data['remainingAmountList'];

                  // Verificar si la lista ya existe en Firebase Firestore
                  if (remainingAmountList != null) {
                    // Agregar el nuevo monto a la lista existente
                    remainingAmountList.add('$remainingAmount');
                  } else {
                    // Crear una nueva lista con el nuevo monto
                    remainingAmountList = ['$remainingAmount'];
                  }

                  // Guardar la lista actualizada en Firebase Firestore
                  await firestore.collection(collection).doc(document).set({
                    'remainingAmountList': remainingAmountList,
                  });

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Resultado'),
                        content: Text(
                            'Tarifa de MP: \$${fees.toStringAsFixed(2)}\nPlata disponible: \$${remainingAmount.toStringAsFixed(2)}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                  setState(() {});
                }
              },
              child: Text(
                'Calcular',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                elevation: MaterialStateProperty.all<double>(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
