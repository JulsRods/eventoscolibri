import 'package:clase5/controlador/autenticar.dart';
import 'package:clase5/models/info.dart';
import 'package:clase5/storage/perfilstorage.dart';
import 'package:clase5/vista/catalogoU_screen.dart';
import 'package:clase5/vista/commen.dart';
import 'package:clase5/vista/homecotizar.dart';
import 'package:clase5/vista/preguntas_frecuente.dart';
import 'package:clase5/widgets/buttom.dart';
import 'package:clase5/widgets/item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeC extends StatefulWidget {
  final String? user;
  const HomeC({super.key, this.user});

  @override
  State<HomeC> createState() => _HomeCState();
}

class _HomeCState extends State<HomeC> {
  List<Info> infos = listOfBags();
  List<String> heroImages = [
    "https://static.wixstatic.com/media/11062b_93446ef9ed4f47898c8d18dfd7dac522~mv2.jpg/v1/fill/w_1628,h_1086,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Sparkling%20Cocktail.jpg",
    "https://static.wixstatic.com/media/11062b_85f2fdac20e64903b2fc8ab8844482c6~mv2.jpg/v1/fill/w_1627,h_1086,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Wedding%20Decorations.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Image.network(
              'https://static.wixstatic.com/media/04b44a_b366ba583f014f019532598992cccace~mv2.png/v1/fill/w_708,h_169,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Logo%20versi%C3%B3n%202%20Eventos%20Colibr%C3%AD_4x_edited.png',
              height: 50,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PerfilPage(user: widget.user),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
              child: Column(children: [
            carousel(),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: infos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 210,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 13,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return BagItem(info: infos[index]);
                  },
                )),
          ])),
          bottomNavigationBar: Container(
            height: 65,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(69),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.home,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CatalogoScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.list_alt_rounded,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeCotScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_bag_rounded,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FaqScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.question_mark_outlined,
                      size: 30,
                    )),
                Stack(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ComentarioScreen()),
                          );
                        },
                        icon: const Icon(
                          Icons.comment,
                          size: 30,
                        )),
                    const Positioned(
                      right: 1,
                      top: 1,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 10,
                        child: Text(
                          "1",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget carousel() {
    return Stack(children: [
      CarouselSlider.builder(
        itemCount: heroImages.length,
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          enlargeCenterPage: true,
        ),
        itemBuilder: (context, index, realIndex) {
          return Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: Image.network(
                  heroImages[index],
                  fit: BoxFit.cover,
                  width: 1000.0,
                ),
              ));
        },
      )
    ]);
  }
}

class _MapScreenState {}

class PerfilPag extends StatelessWidget {
  final String? user;
  const PerfilPag({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para la página
      appBar: AppBar(
        title: const Text('Perfil del Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 80,
                child: Icon(
                  Icons.person,
                  size: 80, // Adjust the size as needed
                ),
              ),
              MyButtons(
                  onTab: () async {
                    await AuthServices().signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const PerfilPage()));
                  },
                  text: "Cerrar Sesión"),
              Text("${FirebaseAuth.instance.currentUser!.email}")
            ],
          ),
        ),
      ),
    );
  }
}
