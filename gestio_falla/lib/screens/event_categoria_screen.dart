import 'package:flutter/material.dart';
import 'package:gestio_falla/screens/event_categoria_detallat_screen.dart';

class EventCategoriaScreen extends StatelessWidget{
  EventCategoriaScreen({super.key});
  final List<String> categories=["Cremà","Festival"];
  
  @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3,
            ),
          itemCount: categories.length,
          itemBuilder: (context, index){
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              elevation: 4,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, 
                    MaterialPageRoute(
                      builder: (context) => EventCategoriaDetallatScreen(categoria: categories[index],)
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                      Color.fromARGB(255, 192, 25, 25),
                      Color.fromARGB(255, 218, 79, 25),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child:Text(
                    categories[index],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  )
                ),
              ),
            );
          }
        ),
      );
    }
}
