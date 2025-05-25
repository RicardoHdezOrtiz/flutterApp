import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mi_primer_proyecto/screens/dashboards_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController conUser = TextEditingController();
  TextEditingController conPdw = TextEditingController();
  bool isLoading = false;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/fondo.jpg')
          )
        ),
        child: Stack(
          
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 100,
              child: Image.asset('assets/logo.jpg', width: 350,)
            ),
            Positioned(
              bottom: 250,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                width: 400,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: conUser,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('Nombre de usuario'),
                        border: OutlineInputBorder()
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: conPdw,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Contraseña',
                        border: OutlineInputBorder()
                      ),
                    )
                  ],
                ),
              )
            ),
            Positioned(
              top: 660,
              child: InkWell(
                onTap: (){
                  isLoading = true;
                  setState(() { });

                  Future.delayed(const Duration(seconds: 4)).then((value) {
                    Navigator.pushNamed(context, '/dash');
                  },);

                  /*Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    )
                  );*/
                },
                child: Lottie.asset('assets/boton.json', width: 220)
              )
            ),
            Positioned(
              top: 250,
              child: isLoading 
                ? Lottie.asset('assets/loading.json', height: 150) 
                : Container()
            )
          ],
        ),
      ),
    );
  }
}
