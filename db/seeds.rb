DumbbellExercise.delete_all

#MotivationalQuote.reset_autoincrement

DumbbellExercise.create!([{
  name: "Dumbbell Biceps Curl",
  dumbbell: "https://www.youtube.com/watch?v=ykJmrZ5v0Oo"
},

{
  name: "Seated Overhead Dumbbell Press",
  dumbbell: "https://www.youtube.com/watch?v=b5JzUH8gsOg"
},

{
  name: "Dumbbell Tricep Extension",
  dumbbell: "https://www.youtube.com/watch?v=_gsUck-7M74"
},

{
  name: "Full-Body Dumbbell Workout",
  dumbbell: "https://www.youtube.com/watch?v=l0gDqsSUtWo"
},

{
  name: "Alternate Dumbbell Curl",
  dumbbell: "https://www.youtube.com/watch?v=8d2we4UqOSs"
},

{
  name: "Hammer Curl",
  dumbbell: "https://www.youtube.com/watch?v=TwD-YGVP4Bk"
},

{
  name: "Concentration Curl",
  dumbbell: "https://www.youtube.com/watch?v=0AUGkch3tzc"
},

{
  name: "Preacher Curl",
  dumbbell: "https://www.youtube.com/watch?v=DoCWeUBA0Gs"
},

{
  name: "Incline Dumbbell Bicep Curl",
  dumbbell: "https://www.youtube.com/watch?v=b4jOP-spQW8"
},

{
  name: "Dumbbell Kick",
  dumbbell: "https://www.youtube.com/watch?v=z3sm6YgpJho"
},

{
  name: "Dumbbell Row",
  dumbbell: "https://www.youtube.com/watch?v=-koP10y1qZI"
}])

p "Created #{DumbbellExercise.count} dumbbell exercises!"


# -----------------------------------------------------------------

BarbellExercise.delete_all

#MotivationalQuote.reset_autoincrement

BarbellExercise.create!([{
  name: "Deep Barbell Back Squat",
  barbell: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  name: "Barbell Front Squat",
  barbell: "https://www.youtube.com/watch?v=tlfahNdNPPI"
},

{
  name: "Deadlift",
  barbell: "https://www.youtube.com/watch?v=RyJbvWAh6ec"
}])

p "Created #{BarbellExercise.count} barbell exercises!"


# -----------------------------------------------------------------


CardioExercise.delete_all

#MotivationalQuote.reset_autoincrement

CardioExercise.create!([{
  name: "High Intensity Cardio Workout for Lean Muscle",
  cardio: "https://www.youtube.com/watch?v=LkCZPvKLeBM"
},

{
  name: "33 Min High Intensity Interval Training for Endurance & Total Body Toning",
  cardio: "https://www.youtube.com/watch?v=H1GDPNYTpqA"
},

{
  name: "HIIT Ladder Workout",
  cardio: "https://www.youtube.com/watch?v=cZnsLVArIt8"
}])

p "Created #{CardioExercise.count} cardio exercises!"


# -----------------------------------------------------------------