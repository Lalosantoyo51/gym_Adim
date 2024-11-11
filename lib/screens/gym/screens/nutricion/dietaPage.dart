import 'package:administrador/screens/gym/models/nutricion.dart';
import 'package:administrador/widgets/colum_builder.dart';
import 'package:flutter/material.dart';

class DietaPage extends StatelessWidget {
  NutricionModel nutricionModel;

  DietaPage({super.key,required this.nutricionModel});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: true,
            pinned: true,
            snap: true,
            actionsIconTheme: const IconThemeData(opacity: 0.0),
            flexibleSpace: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Image.asset(
                      "assets/NutricionBienvenida.png",
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  bottom: -7,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 33,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, bottom: 20, right: 20, top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //// seccion 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("Proteinas"),
                                Stack(
                                  children:  [
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.black,
                                      maxRadius: 30,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        maxRadius: 25,
                                        child: Text("${nutricionModel.proteinas}",
                                            style: const TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Lipidos"),
                                Stack(
                                  children:  [
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.black,
                                      maxRadius: 30,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        maxRadius: 25,
                                        child:Text("${nutricionModel.lipidos}",
                                            style: const TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                               const Text("carbohidratos"),
                                Stack(
                                  children:  [
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.black,
                                      maxRadius: 30,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        maxRadius: 25,
                                        child: Text("${nutricionModel.carbohidratos}",
                                            style: const TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        //// fin seccion 1
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //// seccion 2
                            ColumnBuilder(itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      Text(nutricionModel.comidas![index].titulo,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      Text(nutricionModel.comidas![index].hora.toString() ,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),

                                    ],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(nutricionModel.comidas![index].descripcion))
                                ],
                              ),
                            ), itemCount: nutricionModel.comidas!.length),
                            const SizedBox(height: 20),
                            ////fin seccion 2

                            //// seccion 3
                            const Center(child: Text("Comidas Entrenamiento",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25))),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width/3.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Pre",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(nutricionModel.pre_ent.toString()),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width/3.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Ent.",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(nutricionModel.entrenamiento.toString()),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width/3.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Despues",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(nutricionModel.despues.toString()),
                                    ],
                                  ),
                                ),
                                //// fin seccion 3
                              ],
                            ),
                            // seccion 4
                            Container(
                              margin: EdgeInsets.all(width * .02),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(width * .05)),
                              child: ExpansionTile(
                                title: Text(
                                  "Suplementacion",
                                  style: TextStyle(fontSize: width * .05),
                                ),
                                children: [
                                  ListTile(
                                    title: Text(
                                      "${nutricionModel.suplementacion}",
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(width * .02),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(width * .05)),
                              child: ExpansionTile(
                                title: Text(
                                  "Tips/Indicaciones",
                                  style: TextStyle(fontSize: width * .05),
                                ),
                                children: [
                                  ListTile(
                                    title: Text(
                                      "${nutricionModel.tips}",
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(width * .02),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(width * .05)),
                              child: ExpansionTile(
                                title: Text(
                                  "Obserbaciones",
                                  style: TextStyle(fontSize: width * .05),
                                ),
                                children: [
                                  ListTile(
                                    title: Text(
                                      "${nutricionModel.observaciones}",
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //// fin  seccion 4
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }


}
