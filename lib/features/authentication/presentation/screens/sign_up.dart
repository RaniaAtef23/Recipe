import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_app/features/home/presentation/screens/home_screen.dart';
import 'package:meal_app/features/home/presentation/screens/main_screen.dart';
import 'package:rive/rive.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String animation_url;
  Artboard? _artboard;
  SMITrigger? successTrigger, failTrigger;
  SMIBool? isHandUp, isChecked;
  SMINumber? numlook;
  StateMachineController? _stateMachineController;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();

    animation_url = 'assets/animated_login_character.riv';
    _initializeRiveAnimation();
  }


  Future<void> _initializeRiveAnimation() async {
    // Initialize the Rive library
    await RiveFile.initialize();

    // Load the .riv file after initialization
    rootBundle.load(animation_url).then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      _stateMachineController =
          StateMachineController.fromArtboard(artboard, 'Login Machine');
      if (_stateMachineController != null) {
        artboard.addController(_stateMachineController!);
        _stateMachineController!.inputs.forEach((element) {
          if (element.name == "trigSuccess") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "trigFail") {
            failTrigger = element as SMITrigger;
          } else if (element.name == "isHandsUp") {
            isHandUp = element as SMIBool;
          } else if (element.name == "isChecking") {
            isChecked = element as SMIBool;
          } else if (element.name == "numLook") {
            numlook = element as SMINumber;
          }
        });
      }
      setState(() {
        _artboard = artboard;
      });
    });
    super.initState();
  }
  void handsoneyes(){
    isHandUp?.change(true);

  }
  void lookonfield(){
    isHandUp?.change(false);
    isChecked?.change(true);
    numlook?.change(0);

  }
  void moveeye(val){
    numlook?.change(val.length.toDouble());
  }
  void Login(){
    isChecked?.change(false);
    isHandUp?.change(false);
    setState(() {

    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd6e2ea),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 400,
              height: 300,
              child: _artboard != null
                  ? Rive(artboard: _artboard!, fit: BoxFit.fitWidth)
                  : const CircularProgressIndicator(), // Show a loader or placeholder
            ),
            Container(
              alignment: Alignment.center,
              width: 400,
              padding: const EdgeInsets.only(bottom: 15),
              margin: const EdgeInsets.only(bottom: 15 * 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 15 * 2),
                    TextField(
                      controller: _email,
                      onTap: lookonfield,
                      onChanged: moveeye,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 14),
                      cursorColor: const Color(0xFF832EE5),
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusColor: Color(0xFF832EE5),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF832EE5)),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _password,
                      onTap: handsoneyes,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(fontSize: 14),
                      cursorColor: const Color(0xFF832EE5),
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusColor: Color(0xFF832EE5),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF832EE5)),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed:Login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF832EE5),
                      ),
                      child: const Text("Login",style:  TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Don't Have An Account? ",style: TextStyle(color:Color(
                    0xFF7C7777))),
                Text("Register Now",style: TextStyle(color:Color(0xFF832EE5) ),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
