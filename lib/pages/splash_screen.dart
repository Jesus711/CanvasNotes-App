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
    
    Future.delayed(const Duration(milliseconds: 2200), () {
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
              colors: [
                Color.fromRGBO(161, 161, 157, 1),
                Color.fromRGBO(156, 156, 156, 1),
                Color.fromRGBO(234, 237, 229, 1),
                Color.fromRGBO(145, 147, 151, 1),
                Color.fromRGBO(146, 148, 152, 1)],//[Colors.lightBlue, Colors.blue],
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
                child: const Icon(Icons.draw, size: 80, color: Color.fromRGBO(56, 56, 56, 1), textDirection: TextDirection.ltr,)),
            const SizedBox(height: 12),
            const Text("Canvas Notes", style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromRGBO(56, 56, 56, 1),
                fontSize: 40,
                fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}

