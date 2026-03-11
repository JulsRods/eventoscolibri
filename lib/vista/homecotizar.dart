import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clase5/vista/cotizadorU_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeCotScreen extends StatelessWidget {
  List<String> heroImages = [
    "https://static.wixstatic.com/media/11062b_93446ef9ed4f47898c8d18dfd7dac522~mv2.jpg/v1/fill/w_1628,h_1086,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Sparkling%20Cocktail.jpg",
    "https://static.wixstatic.com/media/11062b_85f2fdac20e64903b2fc8ab8844482c6~mv2.jpg/v1/fill/w_1627,h_1086,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Wedding%20Decorations.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://static.wixstatic.com/media/04b44a_b366ba583f014f019532598992cccace~mv2.png/v1/fill/w_708,h_169,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Logo%20versi%C3%B3n%202%20Eventos%20Colibr%C3%AD_4x_edited.png',
          height: 50,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            carousel(), // Mostrar carrusel primero
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cotiza con nosotros',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Rápido acceso:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildQuickAccessButton(
                          context, 'Cotizador', '/cotizador', Icons.calculate),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(
      BuildContext context, String title, String route, IconData icon) {
    return Card(
      elevation: 4,
      color: Colors.white70,
      child: InkWell(
        onTap: () {
          // Navega a la ruta del cotizador
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CotizarClienteScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.teal[700]),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
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
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Image.network(
                heroImages[index],
                fit: BoxFit.cover,
                width: 1000.0,
              ),
            ),
          );
        },
      )
    ]);
  }
}
