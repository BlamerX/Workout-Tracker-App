import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/src/Workout%20Data/workout_data.dart';

import 'workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controller
  final newWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create new workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text("save"),
          ),
          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text("cancel"),
          ),
        ],
      ),
    );
  }

  // go to workout page
  void gToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  // Save workout
  void save() {
    // get workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;
    // add workout to workoutdata List
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    // pop dialoge box
    Navigator.pop(context);
    clear();
  }

  // cancle
  void cancel() {
    // pop dialoge box
    Navigator.pop(context);
    clear();
  }

  // clear controller
  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Workout Tracker"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getWorkoutList().length,
          itemBuilder: (context, index) => ListTile(
              title: Text(value.getWorkoutList()[index].name),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () =>
                    gToWorkoutPage(value.getWorkoutList()[index].name),
              )),
        ),
      ),
    );
  }
}
