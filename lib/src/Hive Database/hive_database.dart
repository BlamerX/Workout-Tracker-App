import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_tracker/src/DateTime/date_time.dart';

import '../Models/workout.dart';
import '../Models/exercise.dart';

class HiveDatabase {
  // refrence our hive box
  final _myBox = Hive.box("workout_database1");

  // check if there is already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("previous data does NOT exists");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("Previous data does exist");
      return true;
    }
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  // write data
  void saveToDatabase(List<Workout> workouts) {
    // convert workout objects into lists of strings so that we can save in hive
    final workoutList = convertObjectToExerciseList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    /*

    Check if any exercises have been done
    we will put a 0 and 1 for each yyyymmdd date

    */

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS${todaysDateYYYYMMDD()}", 0);
    }

    // "COMPLETION_STATUS_20230129" ->0
    // save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  // read data,and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    // create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      // each workout can have multiple exercises
      List<Exercise> exercisesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        // so add each exercise into a list
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }
      // create individual workout
      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);

      // add individual workout to overall list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  // check if any exercise have been done
  int getCompletedStatus(String yyyymmdd) {
    // returns 0 or 1, if null then return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }

  // return completion status of a given date yyyymmdd
  bool exerciseCompleted(List<Workout> workouts) {
    // go through each workout
    for (var workout in workouts) {
      // go through exercise in workouts
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }
}

// converts workout objects into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    //  [upperbody, lowerbody]
  ];

  for (int i = 0; i < workouts.length; i++) {
    // in each workout,add the name,followed by lists of exercises
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

// converts the exercise in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
    /*  

      [

      Upper Body
      [[biceps,10kg,10reps,3sets],[triceps,20kg,10reps,3sets]],

      Lower Body 
      [[squats,25kg,10reps,3sets],[legraise,30kg,10reps,3sets],[calf,10kg,10reps,3sets]]

      ]

      */
  ];

  // go through each workout
  for (int i = 0; i < workouts.length; i++) {
    // get exercise from each workout
    List<Exercise> exerciseInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [
      // Upper Body
      // [[biceps,10kg,10reps,3sets],[triceps,20kg,10reps,3sets]],
    ];

    // go through each exercise in exerciseList
    for (int j = 0; j < exerciseInWorkout.length; j++) {
      List<String> individualExercise = [
        // [[biceps,10kg,10reps,3sets],[triceps,20kg,10reps,3sets]],
      ];
      individualExercise.addAll(
        {
          exerciseInWorkout[j].name,
          exerciseInWorkout[j].weight,
          exerciseInWorkout[j].reps,
          exerciseInWorkout[j].sets,
          exerciseInWorkout[j].isCompleted.toString(),
        },
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
