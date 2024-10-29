import "package:canvas_notes_flutter/pages/home_page.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "dart:math" as math;

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});


  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  bool _changeIcon = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _changeIcon = !_changeIcon;
      });
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _changeIcon = !_changeIcon;
      });
    });


    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() {
        _changeIcon = !_changeIcon;
      });
    });


    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        _changeIcon = !_changeIcon;
      });
    });
    
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    });
    
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.blue],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
                alignment: Alignment.center,
                transform: _changeIcon ? Matrix4.rotationY(math.pi) : Matrix4.rotationY(0),
                child: const Icon(Icons.draw, size: 80, color: Colors.white, textDirection: TextDirection.ltr,)),
            const SizedBox(height: 12),
            const Text("Canvas Notes", style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}

