import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const WaterIntakeApp());
}

class WaterIntakeApp extends StatelessWidget {
  const WaterIntakeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Intake App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
     home: const WaterIntakeHomepage(),
    );
  }
}class WaterIntakeHomepage extends StatefulWidget {
  const WaterIntakeHomepage({Key? key}) : super(key: key);

  @override
  State<WaterIntakeHomepage> createState() => _WaterIntakeHomepageState();
}

class _WaterIntakeHomepageState extends State<WaterIntakeHomepage> {
  int _waterIntake=0;
  int _dailyGoal=8;
  final List<int>_dailyGoalOption=[8,10,12];

@override
void initState(){
  super.initState();
  _loadPreference();
}
  Future<void>_loadPreference()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      _waterIntake=(pref.getInt('waterIntake')??0);
      _dailyGoal=(pref.getInt('dailyGoal')??8);
    });
  }
  Future<void>_incrementWaterIntake()async{
  SharedPreferences pref=await SharedPreferences.getInstance();
  setState(() {
    _waterIntake++;
    pref.setInt('waterIntake',_waterIntake);
    if(_waterIntake>=_dailyGoal){
      _showGoalDialog();
    }
  });
  }
  Future<void>_resetWaterIntake()async{
  SharedPreferences pref=await SharedPreferences.getInstance();
  setState(() {
    _waterIntake=0;
    pref.setInt('waterIntake', _waterIntake);
  });
  }
  Future<void>_setDailyGoal(int newGoal)async{
  SharedPreferences pref=await SharedPreferences.getInstance();
  setState(() {
    _dailyGoal=newGoal;
    pref.setInt('dailyGoal', newGoal);
  });
  }
  Future<void>_showGoalDialog()async{
  return showDialog<void>(context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
    return AlertDialog(
      title: Text("Congratulation!"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text("You have reached your daily goal of$_dailyGoal glasses of water!")
            
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("Ok"))
      ],
    );
      });
  }
  Future<void>_showResetConfirmDialog()async{
    return showDialog<void>(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Reset water Intake"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("Are you Sure you want to reset your water Intake")

                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("Cancel")),
            TextButton(onPressed: () {
              _resetWaterIntake();
              Navigator.of(context).pop();
            }, child: Text('Reset'))
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
  double progress=_waterIntake/_dailyGoal;
  bool goalReached=_waterIntake>=_dailyGoal;
    return Scaffold(
      appBar: AppBar(
        title: Text('WaterIntake'),
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.water_drop,size: 120,color: Colors.blueAccent,),
SizedBox(height: 20,),
          Text("'You have consumed",style: TextStyle(
            fontSize: 18
          ),),

Text("$_waterIntake glasses of water",style: Theme.of(context).textTheme.headlineMedium)   ,
        SizedBox(height: 20,),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
          minHeight:20,

          ),
          SizedBox(height: 20,),
          Text("Daily Goal",style: TextStyle(fontSize: 18),),
          DropdownButton(value: _dailyGoal,items: _dailyGoalOption.map((int value){
            return DropdownMenuItem(
            value:value,
            child:Text('$value glasses'),

            );

          }).toList(), onChanged:(int? newValue) {
            if(newValue !=null){
              _setDailyGoal(newValue);
            }
          }, ),
          SizedBox(height: 10,),
          ElevatedButton(onPressed:
              goalReached ? null:_incrementWaterIntake
               , child: Text('Add a glass of water',style: TextStyle(fontSize: 18),)),
        SizedBox(height: 20,),
ElevatedButton(onPressed: _showResetConfirmDialog, child: Text('Reset',style: TextStyle(fontSize: 18)))
        ],
      ),
      ),
    );
  }
}

