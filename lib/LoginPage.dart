import 'package:flutter/material.dart';
import 'package:flutter_tododb/TodoApp.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String entername = "";
  String pass = "";

  String nameVal = "pranjal123@gmail.com";
  String passVal = "Pranjal12";

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text("Welcome back!",
                          style: GoogleFonts.quicksand(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          )),
                      Image.asset(
                        "assets/images/login.png",
                        height: 250,
                        width: 250,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          controller: username,
                          maxLength: 20,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter your Email address',
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(132, 0, 0, 0)),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color.fromARGB(166, 0, 0, 0),
                            ),
                            label: const Text("Enter valid username"),
                            labelStyle: const TextStyle(color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter username ";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  child: TextFormField(
                    controller: password,
                    obscureText: true,
                    obscuringCharacter: "*",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      hintStyle:
                          const TextStyle(color: Color.fromARGB(132, 0, 0, 0)),
                      prefixIcon: const Icon(
                        Icons.key,
                        color: Color.fromARGB(166, 0, 0, 0),
                      ),
                      suffixIcon: const Icon(Icons.visibility_off_outlined),
                      label: const Text("Enter  Password"),
                      labelStyle: const TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter valid password ";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
               const  Padding(
                  padding:  EdgeInsets.only(right: 55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     
                      Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.blue),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(120, 63, 90, 112),
                      fixedSize: const Size(250, 60),
                    ),
                    onPressed: () {
                      entername=username.text;
                      pass=password.text;
                      if(entername==nameVal&&pass==passVal){
                        ScaffoldMessenger.of(context).showSnackBar(
                         const  SnackBar(
                            content:Text("Login Successfully!",style: TextStyle(fontSize: 16),),
                            backgroundColor: Colors.green,
                          )
                        );
                        Navigator.push(
                          context,
                           MaterialPageRoute(builder:(context) {
                             return const TodoApp();
                           },)
                           );
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                         const  SnackBar(
                            content:Text("Login Failed Please enter valid information",style: TextStyle(fontSize: 16),),
                            backgroundColor: Colors.red,
                          )
                        );
                      }
                     
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w700),
                    )),
                    const SizedBox(height: 15,),
                  const  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",style: TextStyle(color:Colors.black,fontSize: 15),),
                        Text("  Sign In",style: TextStyle(color:Colors.blue,fontSize: 15),),

                      ],
                    )
              ],
            ),
          ),

        ));
  }
}
