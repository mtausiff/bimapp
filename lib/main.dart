import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Index calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BMI Index calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var wtController = TextEditingController();
  var ftController = TextEditingController();
  var inchController = TextEditingController();
  var errorMessage = "";
  var resultMessage = "";
  var bgColor;
  var resultColor;

  int parseStringToInt(String value){
    return int.parse(value);
  }

  bool validateInvalidValue(String value){
    if(value == '' || value == null || (parseStringToInt(value) <= 0)) return false;
    return true;
  }

  bool validateWeight(String value){
    return validateInvalidValue(value);
  }

  bool validateHeightByType(String value, String type){
    if( !validateInvalidValue(value) || ("inch" == type && parseStringToInt(value)>12)) return false;
    return true;
  }

  void handleError(String _errorMessage){
    setState(() {
      resultMessage = "";
      errorMessage = _errorMessage;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Container(
        color: bgColor,
        child: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('BMI', style: TextStyle(
                  fontSize: 34, fontWeight: FontWeight.w700
                )),
                SizedBox(height: 21,),
                TextField(
                  controller: wtController,
                  decoration: InputDecoration(
                    label: Text('Enter your Weight(in Kgs)'),
                    prefixIcon: Icon(Icons.line_weight),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 11,),
                TextField(
                  controller: ftController,
                  decoration: InputDecoration(
                    label: Text('Enter your Height(in feet)'),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 11,),
                TextField(
                  controller: inchController,
                  decoration: InputDecoration(
                    focusColor: Colors.orange,
                    //hintText: ,
                    label: Text('Enter your Height(in inches)'),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16,),
                ElevatedButton(onPressed: () {
                  var weight = wtController.text.toString();
                  var ftHeight = ftController.text.toString();
                  var inchHeight = inchController.text.toString();

                  if( !validateInvalidValue(weight) && !validateInvalidValue(ftHeight) && !validateInvalidValue(inchHeight))
                  {
                    handleError("Please fill all required fields correctly!!");
                  }
                  else if( !validateWeight(weight))
                  {
                    handleError("Entered Weight value is wrong! It should be greater than 0(Zero)");
                  }
                  else if( !validateInvalidValue(ftHeight))
                  {
                    handleError("Entered Height value in feet is wrong! It should be greater than 0(Zero)");
                  }
                  else if( !validateHeightByType(inchHeight, "inch"))
                  {
                    handleError("Entered Height value in Inches is wrong! It should be in range 1-12");
                  }
                  else
                  {
                    int weightInkg = parseStringToInt(weight);
                    int fth = parseStringToInt(ftHeight);
                    int inh = parseStringToInt(inchHeight);

                    var totalHeightInches = (fth*12) + inh;
                    var heightInMeters = (totalHeightInches*2.54) / 100;
                    var bmi = weightInkg/(heightInMeters*heightInMeters);
                    var message="";
                    if(bmi>25){
                      message = "You are over weight!!";
                      bgColor = Colors.orange.shade100;
                    } else if(bmi<18){
                      message = "You are under weight!!";
                      bgColor = Colors.red.shade100;
                    } else{
                      message = "You are healthy";
                      bgColor = Colors.green.shade100;
                    }
                    setState(() {
                      errorMessage = "";
                      resultMessage = "$message \n Your BMI is: ${bmi.toStringAsFixed(4)}";
                    });
                  }

                }, child: Text('Calculate', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)),
                SizedBox(height: 16,),
                Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 17),),
                Text(resultMessage, style: TextStyle(color: Colors.green, fontSize: 17),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
