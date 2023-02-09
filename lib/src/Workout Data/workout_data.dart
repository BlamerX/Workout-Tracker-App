import 'package:flutter/cupertino.dart';
import 'package:workout_tracker/src/Models/exercise.dart';

import '../Models/workout.dart';

class WorkoutData extends ChangeNotifier {
  /*
  WORKOUT DATA STRUCTURE

  - This overall list contains the different workouts
  - Each workout has a name, and list of exercises

  */
  List<Workout> workoutList = [
    // default workout
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(
          name: "Bicep Curls",
          weight: "10",
          reps: "10",
          sets: "3",
        ),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(
          name: "Squats",
          weight: "10",
          reps: "10",
          sets: "3",
        ),
      ],
    ),
  ];

  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get length of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  // add a workout
  void addWorkout(String name) {
    // add a new workout with a blank list of exercises
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  // add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    // Find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets,
      ),
    );

    notifyListeners();
  }

  // check off the exercise once done
  void checkOffExercise(String workoutName, String exerciseName) {
    // find the relevant workout and erlevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // check off boolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  // returns relevant workout object,given workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  // return relavent exercise object, given a workout name +exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // Find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    // then find the relevant exercise in the workout
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}
