import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/entities/producte.dart';
import 'package:gestio_falla/provider/notificacionsProvider.dart';
import 'package:provider/provider.dart';

class Escudellar extends StatefulWidget{
  final Faller faller;
  final Producte? producte;
  const Escudellar({super.key, required this.faller, required this.producte});

  @override
  State<Escudellar> createState() => EscudellarState();

}

class EscudellarState extends State<Escudellar>{
  int numProductes=1;
  double preuTotal=0;
  bool maxProductes=false;
  bool pagat=false;
  bool cancelat=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Escudellar"),
      centerTitle: true,
      backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context,constrains){
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constrains.maxHeight
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView( 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Quantitat de ${widget.producte!.nom}: $numProductes"),
                          Text("${widget.producte!.nom} restants: ${widget.producte!.stock}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, color: Colors.red),
                                  onPressed: numProductes > 1 ? decrementarNumTickets : null,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.black, width: 1),
                                  ),
                                  child: Text(
                                    "$numProductes",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.green),
                                  onPressed: widget.producte!.stock == 0 ? null : augmentarNumTickets,
                                ),
                              ],
                            ),
                          Text("Preu total: $preuTotal€"),
                          ElevatedButton(
                            onPressed: () {
                              widget.producte!.stock >= 0 && maxProductes == false ? pagar(context) : null;
                            },
                            child: Text("Pagar"),
                          ),
                          Text(
                            maxProductes ? "Ja no queda ${widget.producte!.nom} per a eixe event" : "",
                            style: TextStyle(
                              color: maxProductes ? Colors.red : Colors.white,
                            ),
                          ),
                          Text(pagat ? "Joel" : cancelat ? "Cancelat" : ""),
                          Text(
                            pagat ? "Pagat exitosament" : cancelat ? "Acció cancelada" : "",
                            style: TextStyle(
                              color: pagat ? Colors.green : cancelat ? Colors.red : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      /*
      */
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
                  Navigator.of(context).pop(true); // Torna vertader al tancar
                },
              ),
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false); // Torna fals al tancar
                },
              ),
            ],
          );
        },
      ).then((resultado) {
        // Aquí manejas la respuesta del usuario
        if (resultado != null && resultado) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Has acceptat l'acció")),
          );
          setState(() {
            if(numProductes==1){
              widget.producte!.stock--;
            }
            if (widget.producte!.stock==0){
              numProductes=0;
              maxProductes=true;   
              Text("",
                style: TextStyle(
                  color:Colors.red 
                ),
              ); 
            }else{
              numProductes=1;
            }
            preuTotal=numProductes*widget.producte!.preu;
            pagat=true;
            cancelat=false;
          });
          notificacio();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Has cancelat l'acció")),
          );
          setState(() {
            numProductes--;
            widget.producte!.stock+=numProductes;
            numProductes=1;
            pagat=false;
            cancelat=true;
            preuTotal=numProductes*widget.producte!.preu;
          });
        }
      }
    );
  }

  Future<void> notificacio() async {
    Provider.of<NotificacionsProvider>(context, listen: false).showNotification(
      title: widget.producte!.nom,
      body: '${widget.producte!.nom} per al usuari ${widget.faller.nom} reservada correctament',
    );
  }

  
  void augmentarNumTickets(){
    setState(() {
      numProductes++;
      widget.producte!.stock--;
      preuTotal=numProductes*widget.producte!.preu;
      
    });
    
  }
  void decrementarNumTickets(){
    setState(() {
      numProductes--;
      widget.producte!.stock++;
      preuTotal=numProductes*widget.producte!.preu;
      
    });
  }
}