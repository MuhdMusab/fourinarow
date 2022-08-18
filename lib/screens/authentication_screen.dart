// import 'package:flutter/material.dart';
// import 'package:four_in_a_row/style/palette.dart';
//
// class AuthenticationScreen extends StatefulWidget {
//   const AuthenticationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AuthenticationScreen> createState() => _AuthenticationScreenState();
// }
//
// final formKey = GlobalKey<FormState>();
//
// class _AuthenticationScreenState extends State<AuthenticationScreen> {
//   TextEditingController usernameEditingController = TextEditingController();
//   String? Function(String?) usernameValidator = (val) {
//     return val!.isEmpty || val.length < 4
//         ? "Please provide a longer username"
//         : null;
//   };
//
//   void signIn() {
//     if (formKey.currentState!.validate()) {
//       print('hello');
//     } else {
//       print('yes');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Palette().backgroundLevelSelection,
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Text(
//                 'FourInARow',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 55,
//                     fontFamily: 'Watermelon Days'
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
//               child: Form(
//                 key: formKey,
//                 child: TextFormField(
//                   controller: usernameEditingController,
//                   style: TextStyle(
//                     color: Colors.black,
//                   ),
//                   validator: usernameValidator,
//                   decoration: InputDecoration(
//                     labelText: 'Username',
//                     focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.blue, width: 2.0)
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.blue, width: 2.0)
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.red, width: 0.0)
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 signIn();
//               },
//               child: const Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
