import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notion_test/constants/colors.dart';
import 'package:notion_test/screens/budget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  CarouselController carouselController = CarouselController();
  int indexCarousel = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primary,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: SvgPicture.asset('assets/images/wave.svg', height: 320)
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(height: 20),
                    Text('¡Bienvenido!', style: TextStyle(color: text, fontSize: 38)),
                    SizedBox(height: 5),
                    Text(
                      'Esta aplicación es una integración entre una base de datos en Notion y Flutter. Creado por Luis Manfredi', 
                      style: TextStyle(color: Color(0xFFDCDCDC), fontSize: 14)
                    ),
                    SizedBox(height: 10),
                    /*
                    Row(
                      children: [
                        Image.asset('assets/images/Notion-logo.png', height: 30, width: 30),
                        const FlutterLogo(size: 30)
                      ],
                    )
                    */
                  ],
                ),

                Column(
                  children: [
                    const SizedBox(height: 30),
                    CarouselSlider(
                      carouselController: carouselController,
                      items: [
                        Column(
                          children: [
                            Image.asset('assets/images/Notion-logo.png', height: 250, width: 250),
                            const SizedBox(height: 20),
                            const Text('Notion es un espacio de trabajo todo-en-uno. Una de las funcionalidades principales de Notion es permitir almacenar información en una base de datos.',
                              style: TextStyle(color: text), textAlign: TextAlign.center)
                          ],
                        ),

                        Column(
                          children: [
                            SvgPicture.asset('assets/images/data.svg', height: 250, width: 250),
                            const SizedBox(height: 20),
                            const Text('Haciendo una integración adecuada y siguiendo la guía de Notion para desarrolladores, Notion se transforma en una herramienta muy útil.',
                              style: TextStyle(color: text), textAlign: TextAlign.center)
                          ],
                        ),

                        Column(
                          children: [
                            SvgPicture.asset('assets/images/phone_testing.svg', height: 250, width: 250),
                            const SizedBox(height: 20),
                            const Text('En este caso, hacemos uso de Flutter para crear esta aplicación y recibir los datos que se modifican en la base de datos llamada "Presupuestos".',
                              style: TextStyle(color: text), textAlign: TextAlign.center)
                          ],
                        )
                      ], 
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: 340,
                        onPageChanged: (index, reason) {
                          setState(() {
                            indexCarousel = index;
                          });
                        },
                      )
                    ),

                    const SizedBox(height: 20),

                    AnimatedSmoothIndicator(
                      activeIndex: indexCarousel,
                      count: 3,
                      effect: const WormEffect(
                        activeDotColor: background,
                        dotColor: text,
                        spacing: 20
                      ),
                    )
                  ],
                ),

                ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Budget())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: text,
                    shape: const StadiumBorder(),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 60)
                  ),
                  icon: const Text('Ir a Presupuestos', style: TextStyle(color: primary, fontSize: 20)),
                  label: const Icon(Icons.arrow_forward, color: primary, size: 24),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}