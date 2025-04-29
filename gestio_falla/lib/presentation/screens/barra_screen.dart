import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/producte.dart';
import 'package:gestio_falla/provider/notificacionsProvider.dart';
import 'package:provider/provider.dart';

class Barra extends StatefulWidget{
  const Barra({super.key});

  @override
  State<Barra> createState() => BarraState();

}

class BarraState extends State<Barra>{
  late double preuTotal;
  late String usuari;
  List <Producte>totsElsProductes=[
    Producte(nom: "Aigua 500ml", preu: 1 ,stock: 20),
    Producte(nom: "Cervesa 33cl", preu: 1.5, stock: 33),
    Producte(nom: "Coca-Cola", preu: 1.30, stock: 0),
    Producte(nom: "Pepsi", preu: 1.25, stock: 77),  
  ];
  Map<Producte, int> quantitatsSeleccionades = {};
  @override
  void initState() {
    usuari="Joel";
    preuTotal=0;
    for (var p in totsElsProductes) {
    quantitatsSeleccionades[p] = 0;
  }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barra"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Preu Total: €${preuTotal.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      itemCount: totsElsProductes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.3 / 3,
                      ),
                      itemBuilder: (context, index) {
                        final producte = totsElsProductes[index];
                        final quantitat = quantitatsSeleccionades[producte] ?? 0;
                        final disponible = producte.stock - quantitat;

                        return Card(
                          color: disponible == 0 ? Colors.grey[300] : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(producte.nom, style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    Text("Preu: €${producte.preu.toStringAsFixed(2)}"),
                                    Text("Stock disponible: $disponible"),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove, color: Colors.red),
                                      onPressed: quantitat > 0
                                          ? () {
                                              setState(() {
                                                quantitatsSeleccionades[producte] = quantitat - 1;
                                                preuTotal -= producte.preu;
                                              });
                                            }
                                          : null,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "$quantitat",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add, color: Colors.green),
                                      onPressed: disponible > 0
                                          ? () {
                                              setState(() {
                                                quantitatsSeleccionades[producte] = quantitat + 1;
                                                preuTotal += producte.preu;
                                              });
                                            }
                                          : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton.icon(
                    onPressed: preuTotal > 0 ? () => pagar(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.payment),
                    label: Text("Pagar", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }  
  void pagar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmació"),
          content: Text("Vols pagar ja?"),
          actions: <Widget>[
            TextButton(
              child: Text("Sí"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((resultado) {
      if (resultado != null && resultado) {
        // Aquí actualizamos el stock
        notificacio();
        setState(() {
          quantitatsSeleccionades.forEach((producte, quantitat) {
            producte.stock -= quantitat;
            quantitatsSeleccionades[producte] = 0;
          });
          preuTotal = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Has acceptat l'acció")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Has cancelat l'acció")),
        );
      }
    });
  }
  Future<void> notificacio() async {
    Provider.of<NotificacionsProvider>(context, listen: false).showNotification(
      title: 'Barra',
      body: 'Pagament realitzat pel usuari $usuari amb preu de $preuTotal€ pagat de forma correcta',
    );
  }
}