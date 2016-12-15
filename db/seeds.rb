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


BodybuilderQuote.delete_all

#MotivationalQuote.reset_autoincrement

BodybuilderQuote.create!([{
  name: "Arnold Swarzenegger",
  quote: "“There are no shortcuts—everything is reps, reps, reps.”",
  photo_url: "http://c5.staticflickr.com/3/2751/4104958092_4e0dfb8f40.jpg"
},

{
  name: "Arnold Swarzenegger",
  quote: "“What I’m doing is the thing I want to do. I don’t care what other people think. If the rest of disagrees and says I shouldn’t waste my time, I still will be a bodybuilder. I love it. I love the feeling in my muscles, I love the competition, and I love the things it gives me. I have never really had to work in my whole life. I’ve never had an eight to six job. I’ve always made good money. I’ve traveled all over the world competing and giving exhibitions. I‘ve made a profession out of a pastime, which perhaps only five percent of the population can do. The other ninety-five percent are frustrated office workers, working for someone else. I’m totally independent. So, I…..feel…if I would live again or if I would be born again, I would do exactly the same thing.”",
  photo_url: "http://c3.staticflickr.com/3/2624/4104958034_dabd8a3885.jpg"
},

{
  name: "Arnold Swarzenegger",
  quote: "Just like in bodybuilding, failure is also a necessary experience for growth in our own lives, for if we're never tested to our limits, how will we know how strong we really are? How will we ever grow?",
  photo_url: "http://www.bodybuilding.com/fun/images/2015/arnold-blueprint-mass-training-3-graphics.jpg"
},

{
  name: "Dwayne “The Rock“ Johnson",
  quote: "“Wake up determined. Go to bed satisfied. And somewhere in between eat a cookie.”",
  photo_url: "https://pbs.twimg.com/media/Bh4zZvBIgAAdvSi.jpg"
},

{
  name: "Dwayne “The Rock“ Johnson",
  quote: "“In 1995 I had $7 Bucks in my pocket and knew two things: I’m broke as hell and one day I won’t be.”",
  photo_url: "http://leanmuscularbody.com/wp-content/uploads/2014/07/the-rock-big-muscle-body-2.jpg"
},

{
  name: "Dwayne “The Rock“ Johnson",
  quote: "“Blood, sweat and respect. First two you give, last one you earn.”",
  photo_url: "https://cdn.muscleandstrength.com/sites/default/files/the_rock_feature.jpg"
},

{
  name: "Sylvester Stallone, Rocky Balboa",
  quote: "“Let me tell you something you already know. The world ain't all sunshine and rainbows. It's a very mean and nasty place and I don't care how tough you are it will beat you to your knees and keep you there permanently if you let it. You, me, or nobody is gonna hit as hard as life. But it ain't about how hard ya hit. It's about how hard you can get hit and keep moving forward. How much you can take and keep moving forward. That's how winning is done!”",
  photo_url: "https://s-media-cache-ak0.pinimg.com/236x/c4/6f/3d/c46f3dbb1c1309188e4587fd6a0c0d91.jpg"
},

{
  name: "Sylvester Stallone, Rocky Balboa",
  quote: "“Until you start believing in yourself, you ain’t gonna have a life.”",
  photo_url: "http://www.getholistichealth.com/wp-content/uploads/2012/11/rocky-balboa.jpg"
},

{
  name: "Sylvester Stallone, Rocky Balboa",
  quote: "“It Ain’t How Hard You Hit…It’s How Hard You Can Get Hit and Keep Moving Forward. It's About How Much You Can Take And Keep Moving Forward!”",
  photo_url: "http://www.cineset.com.br/wp-content/uploads/2015/04/70Bt5CDjX5BUoO4GPyBhjPAnOfV.jpg"
},


{
  name: "Mike Tyson",
  quote: "“It doesn’t faze me what anyone says about me. It doesn’t matter what anyone says about me. I’m a totally different entity to what other people think. Michael and Tyson are two different people. I’m Tyson here.”",
  photo_url: "http://healthyceleb.com/wp-content/uploads/2016/03/Mike-Tyson-shirtless-body.jpg"
},

{
  name: "Mike Tyson",
  quote: "“Whatever you want, especially when you’re striving to be the best in the world at something, there’ll always be disappointments, and you can’t be emotionally tied to them, cos’ they’ll break your spirit.”",
  photo_url: "http://wallpapersdsc.net/wp-content/uploads/2015/10/Mike_Tyson_iphone_4.jpeg"
},

{
  name: "Mike Tyson",
  quote: "“I’m a dreamer. I have to dream and reach for the stars, and if I miss a star then I grab a handful of clouds.”",
  photo_url: "http://sports-kings.com/wp-content/uploads/2011/11/mike033.jpg"
},

{
  name: "Muhammad Ali",
  quote: "“Only a man who knows what it is like to be defeated can reach down to the bottom of his soul and come up with the extra ounce of power it takes to win when the match is even.”",
  photo_url: "https://cdn.wittyfeed.com/14052/76bwt1f8epst3engq5iy.jpeg"
},

{
  name: "Muhammad Ali",
  quote: "“Don’t count the days; make the days count.”",
  photo_url: "http://www.famoussportspeople.com/wp-content/uploads/2016/04/4281602-mte5ndg0mdu0odc2ntu0nzy3.jpg"
},

{
  name: "Muhammad Ali",
  quote: "“I am the greatest, I said that even before I knew I was.”",
  photo_url: "http://resize8.indiatvnews.com/en/resize/gallery/860_-/2016/06/muhammad-ali-3-1465024775.jpg"
}])

p "Created #{BodybuilderQuote.count} bodybuilder quotes!"

# -----------------------------------------------------------------

Beforeafter.delete_all

#MotivationalQuote.reset_autoincrement

Beforeafter.create!([{
  name: "Arnold Swarzenegger",
  story: "Arnold went from Average joe in the First picture, which we can only guess he was in his late teens, to winning Mr. Olympia his first time at the age of 23, then winning 7 of them shortly after. He’s gone on record saying that he’s used anabolic steroids for “Tissue Building” while they were legal in the states. Arnold is the Poster boy of Bodybuilding, as he rose to stardom through many Hollywood movies and product promotions.",
  photo_url: "http://proteinfart.proteinfart.netdna-cdn.com/wp-content/uploads/2015/07/arnold-schwarzenegger.jpg"
},

{
  name: "Jay Culter",
  story: "Jay Culter has the body of a construction worker, considering he worked with his Brothers’ Concrete business from the Age of 11. He began training around the age of 18, and later went on to win 4 Mr. Olympia’s during the 2006, 2007, 2009 and 2010 years.",
  photo_url: "http://proteinfart.proteinfart.netdna-cdn.com/wp-content/uploads/2015/07/jay-cutler.jpg"
},

{
  name: "Dwayne ‘The Rock’ Johnson",
  story: "The Rock has always looked big but during Pain and Gain, he became…really big. He was already weighing in at about 250 pounds before he started working out, so he only needed seven meals a day and multiple 60 minute weight training sessions during the day to become the beast you see in the film.",
  photo_url: "http://static.ilykecdn.com/uploads/2016/01/16/sub/74335-large-281431.jpg"
},

{
  name: "Jeff Seid",
  story: "Jeff Seid pictured on the left at age 13, at 120lbs went onto being a Physique competitor with tons of minions following around the internet looking up to him for his love of muscles, raves and women.",
  photo_url: "http://proteinfart.proteinfart.netdna-cdn.com/wp-content/uploads/2015/07/jeff-seid.jpg"
}])

p "Created #{Beforeafter.count} before-and-after stories!"

# -----------------------------------------------------------------

BodyPart.delete_all

#MotivationalQuote.reset_autoincrement

BodyPart.create!([{
  body_part: "Shoulders",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  body_part: "Chest",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  body_part: "Back",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  body_part: "Abs",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  body_part: "Arms",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  body_part: "Glutes",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  body_part: "Legs",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
}])

p "Created #{BodyPart.count} body-part targetted exercises!"

# -----------------------------------------------------------------

WorkoutType.delete_all

#MotivationalQuote.reset_autoincrement

WorkoutType.create!([{
  workout_type: "HIIT",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  workout_type: "Yoga",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  workout_type: "Pilates",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  workout_type: "Tai Chi",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  workout_type: "Zumba",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
},

{
  workout_type: "Aerobics",
  workout_name: "Lorem ipsum",
  url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
}])

p "Created #{WorkoutType.count} workout-type based exercises!"

# -----------------------------------------------------------------

BodyPart.delete_all

#MotivationalQuote.reset_autoincrement

BodyPart.create!([{
  body_part: "Shoulders",
  workout_name: "Shoulder-Gains Workout with Jake Alvarez",
  url: "https://www.youtube.com/watch?v=6EqI5V8AUp8"
},
{
  body_part: "Shoulders",
  workout_name: "Complete Shoulder Workout - Front, Side, & Rear Delts",
  url: "https://www.youtube.com/watch?v=UzsDPUJWInw"
},
{
  body_part: "Shoulders",
  workout_name: "Massive Bowling Ball Shoulder Workout",
  url: "https://www.youtube.com/watch?v=uXzwzBg-6xk"
},

{
  body_part: "Chest",
  workout_name: "3 Highly Effective Chest Workout Techniques for a Bigger Chest",
  url: "https://www.youtube.com/watch?v=blUwlrFpLiU"
},
{
  body_part: "Chest",
  workout_name: "Top 5 Chest Exercises - Rob Riches",
  url: "https://www.youtube.com/watch?v=SK9LNnBbWTc"
},
{
  body_part: "Chest",
  workout_name: "Killer at Home 10-minute Chest Workout",
  url: "https://www.youtube.com/watch?v=Bi1IRzJIoAo"
},

{
  body_part: "Back",
  workout_name: "5 Moves To A Bigger, Stronger Back with Jake Alvarez",
  url: "https://www.youtube.com/watch?v=mcCg_ycMhlA"
},
{
  body_part: "Back",
  workout_name: "Complete Back Workout - Width, Density, Strength!",
  url: "https://www.youtube.com/watch?v=jv8ylu5CQik"
},
{
  body_part: "Back",
  workout_name: "5 Back Exercises for Mass",
  url: "https://www.youtube.com/watch?v=F7-cBttLavU"
},

{
  body_part: "Abs",
  workout_name: "Extreme Six Pack Abs Workout",
  url: "https://www.youtube.com/watch?v=cfY_4m3RVRc"
},
{
  body_part: "Abs",
  workout_name: "12 Min 6 Pack Ab Workout at Home",
  url: "https://www.youtube.com/watch?v=Jm_9n_IUk7s"
},
{
  body_part: "Abs",
  workout_name: "A Simple Daily Ab Workout",
  url: "https://www.youtube.com/watch?v=IwM0NGF-l3c"
},

{
  body_part: "Arms",
  workout_name: "Complete Arm Workout with Zach Zeiler",
  url: "https://www.youtube.com/watch?v=y-pjWIzmxiw"
},
{
  body_part: "Arms",
  workout_name: "Calum Von Moger's Old School Bodybuilding Arms Workout",
  url: "https://www.youtube.com/watch?v=Zb-K7YAzAZM"
},
{
  body_part: "Arms",
  workout_name: "Complete Arm and Shoulder Workout",
  url: "https://www.youtube.com/watch?v=SsN5hWqryjw"
},

{
  body_part: "Glutes",
  workout_name: "Glute Activation & Strengthening Exercises",
  url: "https://www.youtube.com/watch?v=zo_H46Pzuq4"
},
{
  body_part: "Glutes",
  workout_name: "Glute Activation in three steps",
  url: "https://www.youtube.com/watch?v=C0j_KxV6I1k"
},
{
  body_part: "Glutes",
  workout_name: "Killer Glutes Workout Routine",
  url: "https://www.youtube.com/watch?v=rmxnTrEppJI"
},

{
  body_part: "Legs",
  workout_name: "Steve Cook Leg Workout",
  url: "https://www.youtube.com/watch?v=Ha4tOOEMMQI"
},
{
  body_part: "Legs",
  workout_name: "Complete Leg Workout Routine at the Gym",
  url: "https://www.youtube.com/watch?v=PAti3uGRkb8"
},
{
  body_part: "Legs",
  workout_name: "The Big Tree Trunk Leg Workout",
  url: "https://www.youtube.com/watch?v=krdXpT2I_zw"
}])

p "Created #{BodyPart.count} muscle-group based exercises!"

# -----------------------------------------------------------------

Tool.delete_all

#MotivationalQuote.reset_autoincrement

Tool.create!([
  {
    equipment: "Dumbbell",
    workout_name: "Dumbbell Biceps Curl",
    url: "https://www.youtube.com/watch?v=ykJmrZ5v0Oo"
  },

  {
    equipment: "Dumbbell",
    workout_name: "Seated Overhead Dumbbell Press",
    url: "https://www.youtube.com/watch?v=b5JzUH8gsOg"
  },

  {
    equipment: "Dumbbell",
    workout_name: "Dumbbell Tricep Extension",
    url: "https://www.youtube.com/watch?v=_gsUck-7M74"
  },

  {
    equipment: "Dumbbell",
    workout_name: "Full-Body Dumbbell Workout",
    url: "https://www.youtube.com/watch?v=l0gDqsSUtWo"
  },

  {
    equipment: "Dumbbell",
    workout_name: "Alternate Dumbbell Curl",
    url: "https://www.youtube.com/watch?v=8d2we4UqOSs"
  },

  {
    equipment: "Dumbbell",
    workout_name: "Hammer Curl",
    url: "https://www.youtube.com/watch?v=TwD-YGVP4Bk"
  },

  {
    equipment: "Dumbbell",
    workout_name: "Concentration Curl",
    url: "https://www.youtube.com/watch?v=0AUGkch3tzc"
  },

  {
    equipment: "Dumbbell",
    workout_name: "Preacher Curl",
    url: "https://www.youtube.com/watch?v=DoCWeUBA0Gs"
  },

  {
    equipment: "Dumbbell",
    workout_name: "Incline Dumbbell Bicep Curl",
    url: "https://www.youtube.com/watch?v=b4jOP-spQW8"
  },

  {
    equipment: "Dumbbell",
    workout_name: "Dumbbell Kick",
    url: "https://www.youtube.com/watch?v=z3sm6YgpJho"
  },

  {
    equipment: "Dumbbell",
    workout_name: "Dumbbell Row",
    url: "https://www.youtube.com/watch?v=-koP10y1qZI"
  },
  
  {
    equipment: "Barbell",
    workout_name: "Deep Barbell Back Squat",
    url: "https://www.youtube.com/watch?v=SW_C1A-rejs"
  },

  {
    equipment: "Barbell",
    workout_name: "Barbell Front Squat",
    url: "https://www.youtube.com/watch?v=tlfahNdNPPI"
  },

  {
    equipment: "Barbell",
    workout_name: "Deadlift",
    url: "https://www.youtube.com/watch?v=RyJbvWAh6ec"
  },
  
{
  equipment: "Kettle Bell",
  workout_name: "15 Minute Kettlebell Workout Video",
  url: "https://www.youtube.com/watch?v=gcIFAgnOL9E"
},
{
  equipment: "Kettle Bell",
  workout_name: "The 7 Most Important Kettlebell Exercises",
  url: "https://www.youtube.com/watch?v=RjnyMfZb00M"
},
{
  equipment: "Kettle Bell",
  workout_name: "Spartan Kettlebell Workout",
  url: "https://www.youtube.com/watch?v=bMxwbCAIhOw"
},

{
  equipment: "Stability Ball",
  workout_name: "Challenging Exercise Ball Ab Workout",
  url: "https://www.youtube.com/watch?v=gwwNST1hwgI"
},
{
  equipment: "Stability Ball",
  workout_name: "EXTREME Exercise Ball Breakdown Workout!",
  url: "https://www.youtube.com/watch?v=69t3wr4AqN8"
},
{
  equipment: "Stability Ball",
  workout_name: "20 Min Exercise Ball Workout",
  url: "https://www.youtube.com/watch?v=OdKgw__xcHc"
},

{
  equipment: "Medicine Ball",
  workout_name: "Medicine Ball Home Workout",
  url: "https://www.youtube.com/watch?v=BwtaEAr8qI0"
},
{
  equipment: "Medicine Ball",
  workout_name: "Burn More Belly Fat With This Medicine Ball Ab Workout",
  url: "https://www.youtube.com/watch?v=px-Dr102WWE"
},
{
  equipment: "Medicine Ball",
  workout_name: "Total Body Medicine Ball Workout",
  url: "https://www.youtube.com/watch?v=nV3A5F28AB8"
}])

p "Created #{Tool.count} equipment based exercises!"

# -----------------------------------------------------------------

WorkoutType.delete_all

#MotivationalQuote.reset_autoincrement

WorkoutType.create!([{
  workout_type: "HIIT",
  workout_name: "Brutal HIIT Ladder Workout - 20 Minute HIIT Workout at Home",
  url: "https://www.youtube.com/watch?v=cZnsLVArIt8"
},
{
  workout_type: "HIIT",
  workout_name: "HIIT the Ground Running - 33 Min High Intensity Interval Training for Endurance & Total Body Toning",
  url: "https://www.youtube.com/watch?v=H1GDPNYTpqA"
},
{
  workout_type: "HIIT",
  workout_name: "20-Min HIIT Workout Boot Camp - High Intensity Training With No Equipment",
  url: "https://www.youtube.com/watch?v=1y0Pqjnoow0"
},

{
  workout_type: "HIIT",
  workout_name: "High Intensity Cardio Workout for Lean Muscle",
  url: "https://www.youtube.com/watch?v=LkCZPvKLeBM"
},

{
  workout_type: "HIIT",
  workout_name: "33 Min High Intensity Interval Training for Endurance & Total Body Toning",
  url: "https://www.youtube.com/watch?v=H1GDPNYTpqA"
},

{
  workout_type: "Pilates",
  workout_name: "25 Minute Pilates Abs Class | Total Body Core Workout",
  url: "https://www.youtube.com/watch?v=6zi11K4wwds"
},
{
  workout_type: "Pilates",
  workout_name: "Pilates Core Abdominal Workout ",
  url: "https://www.youtube.com/watch?v=iHmH4K4wL4g"
},
{
  workout_type: "Pilates",
  workout_name: "10 min Pilates for Total Beginners Workout",
  url: "https://www.youtube.com/watch?v=2wSQqRUtZuM"
},

{
  workout_type: "Yoga",
  workout_name: "10 Min Yoga for Men Beginner Routine",
  url: "https://www.youtube.com/watch?v=2ymyRJwFtV8"
}, 
{
  workout_type: "Yoga",
  workout_name: "Total Body Yoga Workout With Tim Senesi",
  url: "https://www.youtube.com/watch?v=rQaENEaAHqc"
},
{
  workout_type: "Yoga",
  workout_name: "5 Key Yoga Poses For Men",
  url: "https://www.youtube.com/watch?v=NFOuMSejnO4"
},
 
{
  workout_type: "Tai Chi",
  workout_name: "10 Tai Chi Moves for Beginners - 14 Minute Daily Taiji Routine",
  url: "https://www.youtube.com/watch?v=6w7IS8_UzHM"
},
{
  workout_type: "Tai Chi",
  workout_name: "Daily Tai Chi - 8-minute exercise",
  url: "https://www.youtube.com/watch?v=PNtWqDxwwMg"
},
{
  workout_type: "Tai Chi",
  workout_name: "10 Minute Tai Chi Lesson",
  url: "https://www.youtube.com/watch?v=T4uOAcQr_JA"
},

{
  workout_type: "Aerobics",
  workout_name: "20 Minute Aerobics Workout for Weight Loss",
  url: "https://www.youtube.com/watch?v=141jmEQznK0"
},
{
  workout_type: "Aerobics",
  workout_name: "Low Impact 30 minute cardio workout- Beginner/intermediate",
  url: "https://www.youtube.com/watch?v=50kH47ZztHs"
},
{
  workout_type: "Aerobics",
  workout_name: "25 Min Beginner Cardio Workout at Home",
  url: "https://www.youtube.com/watch?v=-yMkmCGkwXo"
}])

p "Created #{WorkoutType.count} workout-type based exercises!"

# -----------------------------------------------------------------









