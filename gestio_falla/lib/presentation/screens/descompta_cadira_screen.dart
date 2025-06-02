import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/provider/notificacionsProvider.dart';
import 'package:provider/provider.dart';

class DescomptaCadira extends StatefulWidget{
  final Faller? faller;
   final Event? event;
  const DescomptaCadira({super.key, required this.faller, required this.event});
  
  @override
  State<DescomptaCadira> createState() => DescomptaCadiraState();
}
class DescomptaCadiraState extends State<DescomptaCadira>{
  int cadiresAssignades=1;
  int cadiresRestants=10;
  bool maxCadires=false;
  double preu=1;
  late double preuTotal;
  bool pagat=false;
  bool cancelat=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preuTotal=preu;
    widget.event!.numcadires=cadiresAssignades;
    cadiresRestants-=widget.event!.numcadires;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pantalla per a reservar cadires"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child:  ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child:Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Text(widget.event!.nom),
                      Text("Data d'inici: ${widget.event!.dataIniciFormatejada}"),
                      Text("Data de fi: ${widget.event!.dataFiFormatejada}"),
                      Text("Quantitat de cadires: ${widget.event!.numcadires}"),
                      Text("Cadires restants: $cadiresRestants"),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Quants tickets vols?"),
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.red),
                            onPressed: widget.event!.numcadires>1 ? decrementarNumTickets : null,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Text(
                              "${widget.event!.numcadires}",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.green),
                            onPressed: cadiresRestants==0 ?null :augmentarNumTickets,
                          ),
                        ],
                      ),
                      Text("Preu total: $preuTotal€"),
                      ElevatedButton(onPressed:(){
                        cadiresRestants>=0&&maxCadires==false? pagar(context) : null;
                        }, 
                        child: Text("Pagar")
                      ),
                      Text(maxCadires?"Ja no queden cadires per a eixe event":"",
                        style: TextStyle(
                          color: maxCadires?Colors.red:Colors.white
                        ),
                      ),
                      Text(pagat ?"Joel":cancelat?"Cancelat":""),
                      Text(pagat ?"Pagat exitosament":cancelat?"Acció cancelada":"",
                        style:TextStyle( 
                          color: pagat?Colors.green:cancelat?Colors.red:Colors.white
                        ),
                      ),
                    ],
                  )
                ),
              ),
              ),
            );
          }
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
            if(widget.event!.numcadires==1){
              cadiresRestants--;
            }
            if (cadiresRestants==0){
              widget.event!.numcadires=0;
              maxCadires=true;   
              Text("",
                style: TextStyle(
                  color:Colors.red 
                ),
              ); 
            }else{
             widget. event!.numcadires=1;
            }
            preuTotal=widget.event!.numcadires*preu;
            pagat=true;
            cancelat=false;
          });
          notificacio();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Has cancelat l'acció")),
          );
          setState(() {
            widget.event!.numcadires--;
            cadiresRestants+=widget.event!.numcadires;
            widget.event!.numcadires=1;
            pagat=false;
            cancelat=true;
            preuTotal=widget.event!.numcadires*preu;
          });
        }
      }
    );
  }

  Future<void> notificacio() async {
    Provider.of<NotificacionsProvider>(context, listen: false).showNotification(
      title: 'Cadires',
      body: 'Cadires al usuari ${widget.faller!.nom} reservades correctament',
    );
  }

  
  void augmentarNumTickets(){
    setState(() {
      widget.event!.numcadires++;
      cadiresRestants--;
      preuTotal=widget.event!.numcadires*preu;
      
    });
    
  }
  void decrementarNumTickets(){
    setState(() {
      widget.event!.numcadires--;
      cadiresRestants++;
      preuTotal=widget.event!.numcadires*preu;
      
    });
  }
}