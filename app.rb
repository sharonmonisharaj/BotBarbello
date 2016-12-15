require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'rake'
require 'slack-ruby-client'
require 'httparty'
require 'rainbow'
require 'haml'

# ----------------------------------------------------------------------

configure :development do
  require 'dotenv'
  Dotenv.load
end

# ----------------------------------------------------------------------

require_relative 'app'
require_relative './models/dumbbell_exercise'
require_relative './models/barbell_exercise'
require_relative './models/cardio_exercise'
require_relative './models/bodybuilder_quote'
require_relative './models/beforeafter'
require_relative './models/body_part'
require_relative './models/tool'
require_relative './models/workout_type'
require_relative './models/team'
require_relative './models/event'

# enable sessions for this project
enable :sessions

# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

get "/" do
  haml :index
end

get "/privacy" do
  "Privacy Statement"
end

get "/about" do
  "About this app"
end

# ----------------------------------------------------------------------

get "/login/:user" do  
  send_slack_request "Good news\n #{params[:user]} just signed into the app.", ["https://github.com/daraghbyrne"]
end 

# ----------------------------------------------------------------------

get "/oauth" do 
  
  code = params[ :code ]
  
  slack_oauth_request = "https://slack.com/api/oauth.access"
  
  if code 
    response = HTTParty.post slack_oauth_request, body: {client_id: ENV['SLACK_CLIENT_ID'], client_secret: ENV['SLACK_CLIENT_SECRET'], code: code}
    
    puts response.to_s
    
    # We can extract lots of information from this web hook... 
    
    access_token = response["access_token"]
    team_name = response["team_name"]
    team_id = response["team_id"]
    user_id = response["user_id"]
        
    incoming_channel = response['incoming_webhook']['channel']
    incoming_channel_id = response['incoming_webhook']['channel_id']
    incoming_config_url = response['incoming_webhook']['configuration_url']
    incoming_url = response['incoming_webhook']['url']
    
    bot_user_id = response['bot']['bot_user_id']
    bot_access_token = response['bot']['bot_access_token']
    
    # wouldn't it be useful if we could store this? 
    # we can... 
    
    team = Team.find_or_create_by( team_id: team_id, user_id: user_id )
    team.access_token = access_token
    team.team_name = team_name
    team.raw_json = response.to_s
    team.incoming_channel = incoming_channel
    team.incoming_webhook = incoming_url
    team.bot_token = bot_access_token
    team.bot_user_id = bot_user_id
    team.save
    
    # finally respond... 
    "CourseBot Slack App successfully installed!"
    
  else
    401
  end
  
end

# ----------------------------------------------------------------------
#     MONITOR EVENTS
# ----------------------------------------------------------------------

post "/events" do 
  request.body.rewind
  raw_body = request.body.read
  puts "Raw: " + raw_body.to_s
  
  json_request = JSON.parse( raw_body )

  # check for a URL Verification request.
  if json_request['type'] == 'url_verification'
      content_type :json
      return {challenge: json_request['challenge']}.to_json
  end

  if json_request['token'] != ENV['SLACK_VERIFICATION_TOKEN']
      halt 403, 'Incorrect slack token'
  end

  respond_to_slack_event json_request
  
  # always respond with a 200
  # event otherwise it will retry...
  200
  
end

# ----------------------------------------------------------------------

post "/interactive_buttons/" do
  content_type :json
  request.body.rewind
  raw_body = request.body.read
  puts "Params: " + params.to_s
  #puts "Raw: " + raw_body.to_s
  
  json_request = JSON.parse( params["payload"] )
  puts "JSON = " + json_request.to_s
  puts "checking token"
  if json_request['token'] != ENV['SLACK_VERIFICATION_TOKEN']
      halt 403, 'Incorrect slack token'
  end
  
  puts "token valid"
  call_back = json_request['callback_id']
  action_name = json_request['actions'].first["name"]
  action_value = json_request['actions'].first["value"]
  channel = json_request['channel']['id']
  team_id = json_request['team']['id']
  
  puts "Action: " + call_back.to_s
  puts "Call Back: " + action_name.to_s
  puts "team_id : " + team_id.to_s
  puts "channel : " + channel.to_s
  
  
  team = Team.find_by( team_id: team_id )
  
  # didn't find a match... this is junk! 
  return if team.nil?
  
  puts "team found :" 
  
  client = team.get_client
  
# ----------  
  
 if call_back == "intro"
      replace_message = "Cool!" 
      puts "found match "
    
      if action_name == "start_workout"
        attachments =  step_one 
        client.chat_postMessage(channel: channel, text: "Aaaaare youuuuu readyyyy! Let's get started!", attachments: attachments, as_user: true)
        
      else
        replace_message = "Try typing 'start workout'"
        client.chat_postMessage(channel: channel, text: "It's all under control! You got this cowboy!", as_user: true)
      end
      
 # ----------     
      
  elsif call_back == "step_one"
           puts "found match "
    
      if action_name == "muscle_group"
        attachments =  muscle_group 
        client.chat_postMessage(channel: channel, text: "Muscle group, eh? Whatever you say brother!", attachments: attachments, as_user: true)
        
      elsif action_name == "equipment"
        attachments =  equipment
        client.chat_postMessage(channel: channel, text: "Equipment! I like ya!", attachments: attachments, as_user: true)     
      
      elsif action_name == "workout_type"
        attachments =  workout_type
        client.chat_postMessage(channel: channel, text: "Workout type, let's do this!", attachments: attachments, as_user: true)
        
      else
        replace_message = "Try typing 'start workout'"
        client.chat_postMessage(channel: channel, text: "It's all under control! You got this cowboy!", as_user: true)
      end
     
# ----------      
  
  elsif call_back == "muscle_group"
             puts "found match "
                 
      if action_name == "upper_body"
        attachments =  upper_body 
        client.chat_postMessage(channel: channel, text: "You chose upper body! We're gonna have a partyy! Hey that rhymes!! Ain't I awesome!", attachments: attachments, as_user: true)
        
      elsif action_name == "lower_body"
        attachments =  lower_body 
        client.chat_postMessage(channel: channel, text: "Ah, lower body? May the force be with ya!", attachments: attachments, as_user: true)
      
      else
        replace_message = "Try typing 'start workout'"
        client.chat_postMessage(channel: channel, text: "It's all under control! You got this cowboy!", as_user: true)
      end
 
# ----------

  elsif call_back == "upper_body"
             puts "found match "
                 
      if action_name == "shoulders"
       client.chat_postMessage(channel: channel, text: "Sometimes we all need a shoulder to cry on. Those shoulders better be strong bro!\n\n*#{BodyPart.all.where(body_part: "Shoulders").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Shoulders").sample.url}", attachments: attachments, as_user: true)
        
      elsif action_name == "chest"
       client.chat_postMessage(channel: channel, text: "I'm a big fan of Elvis, man. I got 'Heartbreak Hotel' tattooed on my chest!\n\n*#{BodyPart.all.where(body_part: "Chest").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Chest").sample.url}", attachments: attachments, as_user: true)
       
     elsif action_name == "back"
      client.chat_postMessage(channel: channel, text: "I've got your back bro!\n\n*#{BodyPart.all.where(body_part: "Back").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Back").sample.url}", attachments: attachments, as_user: true)
      
    elsif action_name == "abs"
     client.chat_postMessage(channel: channel, text: "That awkward moment when you're walking through the metal detector and your abs of steel set it off! I live for that!\n\n*#{BodyPart.all.where(body_part: "Abs").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Abs").sample.url}", attachments: attachments, as_user: true)
     
   elsif action_name == "arms"
    client.chat_postMessage(channel: channel, text: "Did ya know our arms start from the back cuz they were once wings?!\n\n*#{BodyPart.all.where(body_part: "Arms").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Arms").sample.url}", attachments: attachments, as_user: true)
      
      else
        replace_message = "Try typing 'start workout'"
        client.chat_postMessage(channel: channel, text: "It's all under control! You got this cowboy!", as_user: true)
      end
 
# ----------

  elsif call_back == "lower_body"
             puts "found match "
                 
      if action_name == "glutes"
       client.chat_postMessage(channel: channel, text: "No glutes, no glory!\n\n*#{BodyPart.all.where(body_part: "Glutes").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Glutes").sample.url}", attachments: attachments, as_user: true)
     
   elsif action_name == "legs"
    client.chat_postMessage(channel: channel, text: "When your legs get tired, run with your heart bro!\n\n*#{BodyPart.all.where(body_part: "Legs").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Legs").sample.url}", attachments: attachments, as_user: true)
      
      else
        replace_message = "Try typing 'start workout'"
        client.chat_postMessage(channel: channel, text: "It's all under control! You got this cowboy!", as_user: true)
      end
 
# ----------

  elsif call_back == "workout_type"
             puts "found match "
                 
      if action_name == "hiit"
       client.chat_postMessage(channel: channel, text: "Will it be easy? Nope! Worth it? Absolutely!\n\n*#{WorkoutType.all.where(workout_type: "HIIT").sample.workout_name}*\n#{WorkoutType.all.where(workout_type: "HIIT").sample.url}", attachments: attachments, as_user: true)
     
   elsif action_name == "pilates"
    client.chat_postMessage(channel: channel, text: "All ya need is love! And Pilates!!\n\n*#{WorkoutType.all.where(workout_type: "Pilates").sample.workout_name}*\n#{WorkoutType.all.where(workout_type: "Pilates").sample.url}", attachments: attachments, as_user: true)
    
  elsif action_name == "yoga"
   client.chat_postMessage(channel: channel, text: "Inhale the future, exhale the past. Piece of cake!\n\n*#{WorkoutType.all.where(workout_type: "Yoga").sample.workout_name}*\n#{WorkoutType.all.where(workout_type: "Yoga").sample.url}", attachments: attachments, as_user: true)
   
 elsif action_name == "tai_chi"
  client.chat_postMessage(channel: channel, text: "Hey dude! Did ya get your morning cup of tai chi?\n\n*#{WorkoutType.all.where(workout_type: "Tai Chi").sample.workout_name}*\n#{WorkoutType.all.where(workout_type: "Tai Chi").sample.url}", attachments: attachments, as_user: true)
  
elsif action_name == "aerobics"
 client.chat_postMessage(channel: channel, text: "Yo cowboy! Good things come to those that sweat!\n\n*#{WorkoutType.all.where(workout_type: "Aerobics").sample.workout_name}*\n#{WorkoutType.all.where(workout_type: "Aerobics").sample.url}", attachments: attachments, as_user: true)
      
      else
        replace_message = "Try typing 'start workout'"
        client.chat_postMessage(channel: channel, text: "It's all under control! You got this cowboy!", as_user: true)
      end
 
# ----------
  
  elsif call_back == "equipment"
             puts "found match "
                 
      if action_name == "dumbbells"
        client.chat_postMessage(channel: channel, text: "Know your limits, then crush 'em!\n\n*#{DumbbellExercise.all.sample(1).first.name}*\n#{DumbbellExercise.all.sample(1).first.dumbbell}", attachments: attachments, as_user: true)
        
      elsif action_name == "barbell"
        client.chat_postMessage(channel: channel, text: "Don't do your best man! Do whatever it takes!\n\n*#{BarbellExercise.all.sample(1).first.name}*\n#{BarbellExercise.all.sample(1).first.barbell}", attachments: attachments, as_user: true)
        
      elsif action_name == "kettle_bell"
       client.chat_postMessage(channel: channel, text: "Remember brother, pain is just weakness leaving the body!\n\n*#{Tool.all.where(equipment: "Kettle Bell").sample.workout_name}*\n#{Tool.all.where(equipment: "Kettle Bell").sample.url}", attachments: attachments, as_user: true)
       
     elsif action_name == "stability_ball"
      client.chat_postMessage(channel: channel, text: "The only bad workout is the one that never happened. Make this happen!\n\n*#{Tool.all.where(equipment: "Stability Ball").sample.workout_name}*\n#{Tool.all.where(equipment: "Stability Ball").sample.url}", attachments: attachments, as_user: true)
      
    elsif action_name == "medicine_ball"
     client.chat_postMessage(channel: channel, text: "Do it because they said you couldn't!\n\n*#{Tool.all.where(equipment: "Medicine Ball").sample.workout_name}*\n#{Tool.all.where(equipment: "Medicine Ball").sample.url}", attachments: attachments, as_user: true)
      
      else
        replace_message = "Try typing 'start workout'"
        client.chat_postMessage(channel: channel, text: "It's all under control! You got this cowboy!", as_user: true)
      end
 
# ----------
      
    {text: replace_message, replace_original: true }.to_json
  else
    200
  end
  
end 

# ----------------------------------------------------------------------
#     SLASH COMMANDS
# ----------------------------------------------------------------------

post "/workout/"  do
  
  puts params.to_s

  slack_token = "Upm2rHVBhulKzKd3MsKYP8Cz"

  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]

    
    greeting = ["Hey dude!", "Hey man!", "Hey brother!", "It's great to see you bro!"]
    
     if text.downcase.strip == "dumbbell"
       random = Tool.all.where(equipment: "Dumbbell").sample
       formatted_message = greeting.sample + " Here's your new dumbbell workout video!\n\n" + "*#{random.workout_name}*" + "\n" + random.url
     
     
     elsif text.downcase.strip == "barbell"
       random = Tool.all.where(equipment: "Stability Ball").sample
       formatted_message = greeting.sample + " Here's your new barbell workout video!\n\n" + "*#{random.workout_name}*" + "\n" + random.url
    
     
     elsif text.downcase.strip == "cardio"
       random = WorkoutType.all.where(workout_type: "HIIT").sample
       formatted_message = greeting.sample + " Here's your new cardio workout video!\n\n" + "*#{random.workout_name}*" + "\n" + random.url
  
     else 
       random = BodyPart.all.sample(1).first
       formatted_message = greeting.sample + " Here's a new workout video!\n\n" + "*#{random.workout_name}*" + "\n" + random.url
     end

    content_type :json
  
    {text: formatted_message, response_type: "in_channel" }.to_json

  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end
end

# ----------------------------------------------------------------------

post "/inspire/"  do
  
  puts params.to_s

  slack_token = "Upm2rHVBhulKzKd3MsKYP8Cz"

  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]

    
     if text.downcase.strip == "ali"
       ali = BodybuilderQuote.all.where( name: "Muhammad Ali" )
       random = ali.sample
       formatted_message = random.quote + "\n - " + random.name + "\n" + random.photo_url
       
    elsif text.downcase.strip == "arnold"
      arnold = BodybuilderQuote.all.where( name: "Arnold Swarzenegger" )
      random = arnold.sample
      formatted_message = random.quote + "\n - " + random.name + "\n" + random.photo_url
      
    elsif text.downcase.strip == "rock"
      rock = BodybuilderQuote.all.where( name: "Dwayne “The Rock“ Johnson" )
      random = rock.sample
      formatted_message = random.quote + "\n - " + random.name + "\n" + random.photo_url
      
    elsif text.downcase.strip == "stallone"
      stallone = BodybuilderQuote.all.where( name: "Sylvester Stallone, Rocky Balboa" )
      random = stallone.sample
      formatted_message = random.quote + "\n - " + random.name + "\n" + random.photo_url
      
    elsif text.downcase.strip == "tyson"
      tyson = BodybuilderQuote.all.where( name: "Mike Tyson" )
      random = tyson.sample
      formatted_message = random.quote + "\n - " + random.name + "\n" + random.photo_url
    
           
     else 
       random = BodybuilderQuote.all.sample(1).first
       formatted_message = random.quote + "\n - " + random.name + "\n" + random.photo_url
     end

    content_type :json
  
    {text: formatted_message, response_type: "in_channel" }.to_json

  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end
end

# ----------------------------------------------------------------------

post "/beforeafter/"  do
  
  puts params.to_s

  slack_token = "Upm2rHVBhulKzKd3MsKYP8Cz"

  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]

    random = Beforeafter.all.sample(1).first
    formatted_message = random.name + "\n" + random.story + "\n" + random.photo_url

    content_type :json
  
    {text: formatted_message, response_type: "in_channel" }.to_json

  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end
end

# ----------------------------------------------------------------------
#     ERRORS
# ----------------------------------------------------------------------

error 401 do 
  "Whoops! Not allowed!!!"
end

# ----------------------------------------------------------------------
#   METHODS
# ----------------------------------------------------------------------

private

def send_slack_request message

  slack_webhook = "https://hooks.slack.com/services/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"
  
  HTTParty.post slack_webhook, body: { text: message.to_s, username: "AppBot", channel: "bots"}.to_json, headers: {'content-type' => 'application/json'}

  response
  
end

# ----------------------------------------------------------------------  

def respond_to_slack_event json
  
  # find the team 
  team_id = json['team_id']
  api_app_id = json['api_app_id']
  event = json['event']
  event_type = event['type']
  event_user = event['user']
  event_text = event['text']
  event_channel = event['channel']
  event_ts = event['ts']
  
  team = Team.find_by( team_id: team_id )
  
  # didn't find a match... this is junk! 
  return if team.nil?
  
  # see if the event user is the bot user 
  # if so we shoud ignore the event
  return if team.bot_user_id == event_user
  
  event = Event.create( team_id: team_id, type_name: event_type, user_id: event_user, text: event_text, channel: event_channel , timestamp: Time.at(event_ts.to_f) )
  event.team = team 
  event.save
  
  client = team.get_client
  
  #event_to_action client, event 
  
  # Action commands
  if ["hi", "hey", "hello", "start", "bot"].any? { |w| event.formatted_text.starts_with? w }  
    attachments =  intro 
    client.chat_postMessage(channel: event.channel, text: "*Yo dude! I'm BotBarbello, your fitness buddy!*\nhttp://i61.photobucket.com/albums/h63/sharonmonisharaj/BotBarbello-02_zpsldw6vcre.png~original\n\n*Here's the lingo I understand brother!*\n\n- Type `/inspire` to be inspired by a smashing quote from an ultra famous celebrity bodybuilder you probably adore!\n- Type `/beforeafter` for inspiring before and after photos of famous bodybuilders!\n- Type `/workout` for a quick workout video handpicked by yours truly!\n- Type `help` if you're stuck!\n\n\n*Demand a workout video for any of the following by simply typing -*\n\n`shoulders` | `chest` | `back` | `abs` | `arms` | `glutes` | `legs`\n`dumbbells` | `kettle bell` | `barbell` | `stability ball` | `medicine ball`\n`interval training` | `pilates` | `yoga` | `tai chi` | `aerobics`\n", attachments: attachments, as_user: true)

    # http://i61.photobucket.com/albums/h63/sharonmonisharaj/BotBarbello-02_zpsldw6vcre.png~original
    
    # http://i61.photobucket.com/albums/h63/sharonmonisharaj/BotBarbello-02_zpsldw6vcre.png?t=1481464559

  elsif ["muscle group"].any? { |w| event.formatted_text.starts_with? w }  
    attachments =  muscle_group 
    client.chat_postMessage(channel: event.channel, text: "Muscle group, eh? Whatever you say brother!", attachments: attachments, as_user: true)


  elsif ["upper body"].any? { |w| event.formatted_text.starts_with? w }  
    attachments =  upper_body 
    client.chat_postMessage(channel: event.channel, text: "You chose upper body! We're gonna have a partyy! Hey that rhymes!! Ain't I awesome!", attachments: attachments, as_user: true)


  elsif ["lower body"].any? { |w| event.formatted_text.starts_with? w }  
    attachments =  lower_body 
    client.chat_postMessage(channel: event.channel, text: "Ah, lower body? May the force be with ya!", attachments: attachments, as_user: true)
    
    
  elsif ["equipment"].any? { |w| event.formatted_text.starts_with? w }  
    attachments =  equipment 
    client.chat_postMessage(channel: event.channel, text: "Equipment?! I like ya!", attachments: attachments, as_user: true)
    
    
  elsif ["workout type"].any? { |w| event.formatted_text.starts_with? w }  
    attachments =  workout_type 
    client.chat_postMessage(channel: event.channel, text: "Workout type, let's do this!", attachments: attachments, as_user: true)
    
    
   elsif ["shoulder"].any? { |w| event.formatted_text.starts_with? w } 
     client.chat_postMessage(channel: event.channel, text: "Sometimes we all need a shoulder to cry on. Those shoulders better be strong bro!\n\n*#{BodyPart.all.where(body_part: "Shoulders").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Shoulders").sample.url}", as_user: true)
     
     
   elsif ["chest"].any? { |w| event.formatted_text.starts_with? w } 
     client.chat_postMessage(channel: event.channel, text: "I'm a big fan of Elvis, man. I got 'Heartbreak Hotel' tattooed on my chest!\n\n*#{BodyPart.all.where(body_part: "Chest").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Chest").sample.url}", attachments: attachments, as_user: true)
     
     
   elsif ["back"].any? { |w| event.formatted_text.starts_with? w } 
     client.chat_postMessage(channel: event.channel, text: "I've got your back bro!\n\n*#{BodyPart.all.where(body_part: "Back").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Back").sample.url}", attachments: attachments, as_user: true)
     
     
   elsif ["abs"].any? { |w| event.formatted_text.starts_with? w } 
     client.chat_postMessage(channel: event.channel, text: "That awkward moment when you're walking through the metal detector and your abs of steel set it off! I live for that!\n\n*#{BodyPart.all.where(body_part: "Abs").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Abs").sample.url}", attachments: attachments, as_user: true)
     
     
   elsif ["arms"].any? { |w| event.formatted_text.starts_with? w } 
    client.chat_postMessage(channel: event.channel, text: "Did ya know our arms start from the back cuz they were once wings?!\n\n*#{BodyPart.all.where(body_part: "Arms").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Arms").sample.url}", attachments: attachments, as_user: true)
     
     
   elsif ["glutes"].any? { |w| event.formatted_text.starts_with? w } 
     client.chat_postMessage(channel: event.channel, text: "No glutes, no glory!\n\n*#{BodyPart.all.where(body_part: "Glutes").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Glutes").sample.url}", attachments: attachments, as_user: true)
     
     
   elsif ["legs"].any? { |w| event.formatted_text.starts_with? w } 
     client.chat_postMessage(channel: event.channel, text: "When your legs get tired, run with your heart bro!\n\n*#{BodyPart.all.where(body_part: "Legs").sample.workout_name}*\n#{BodyPart.all.where(body_part: "Legs").sample.url}", attachments: attachments, as_user: true)
     
     
   elsif ["interval"].any? { |w| event.formatted_text.starts_with? w } 
    client.chat_postMessage(channel: event.channel, text: "Will it be easy? Nope! Worth it? Absolutely!\n\n*#{WorkoutType.all.where(workout_type: "HIIT").sample.workout_name}*\n#{WorkoutType.all.where(workout_type: "HIIT").sample.url}", attachments: attachments, as_user: true)
     
     
   elsif ["pilates"].any? { |w| event.formatted_text.starts_with? w } 
     client.chat_postMessage(channel: event.channel, text: "All ya need is love! And Pilates!!\n\n*#{WorkoutType.all.where(workout_type: "Pilates").sample.workout_name}*\n#{WorkoutType.all.where(workout_type: "Pilates").sample.url}", attachments: attachments, as_user: true)
     
     
   elsif ["yoga"].any? { |w| event.formatted_text.starts_with? w } 
     client.chat_postMessage(channel: event.channel, text: "Inhale the future, exhale the past. Piece of cake!\n\n*#{WorkoutType.all.where(workout_type: "Yoga").sample.workout_name}*\n#{WorkoutType.all.where(workout_type: "Yoga").sample.url}", attachments: attachments, as_user: true)
     
     
   elsif ["tai chi", "taichi"].any? { |w| event.formatted_text.starts_with? w } 
     client.chat_postMessage(channel: event.channel, text: "Hey dude! Did ya get your morning cup of tai chi?\n\n*#{WorkoutType.all.where(workout_type: "Tai Chi").sample.workout_name}*\n#{WorkoutType.all.where(workout_type: "Tai Chi").sample.url}", attachments: attachments, as_user: true)
     
     
   elsif ["aerobics"].any? { |w| event.formatted_text.starts_with? w } 
    client.chat_postMessage(channel: event.channel, text: "Yo cowboy! Good things come to those that sweat!\n\n*#{WorkoutType.all.where(workout_type: "Aerobics").sample.workout_name}*\n#{WorkoutType.all.where(workout_type: "Aerobics").sample.url}", attachments: attachments, as_user: true)
    
    
  elsif ["barbell"].any? { |w| event.formatted_text.starts_with? w } 
    client.chat_postMessage(channel: event.channel, text: "Don't do your best man! Do whatever it takes!\n\n*#{BarbellExercise.all.sample(1).first.name}*\n#{BarbellExercise.all.sample(1).first.barbell}", attachments: attachments, as_user: true)
   
   
 elsif ["dumbbell"].any? { |w| event.formatted_text.starts_with? w } 
  client.chat_postMessage(channel: event.channel, text: "Know your limits, then crush 'em!\n\n*#{DumbbellExercise.all.sample(1).first.name}*\n#{DumbbellExercise.all.sample(1).first.dumbbell}", attachments: attachments, as_user: true)
  
  
elsif ["kettle bell"].any? { |w| event.formatted_text.starts_with? w } 
 client.chat_postMessage(channel: event.channel, text: "Remember brother, pain is just weakness leaving the body!\n\n*#{Tool.all.where(equipment: "Kettle Bell").sample.workout_name}*\n#{Tool.all.where(equipment: "Kettle Bell").sample.url}", attachments: attachments, as_user: true)
 
 
elsif ["stability ball","exercise ball"].any? { |w| event.formatted_text.starts_with? w } 
 client.chat_postMessage(channel: event.channel, text: "The only bad workout is the one that never happened. Make this happen!\n\n*#{Tool.all.where(equipment: "Stability Ball").sample.workout_name}*\n#{Tool.all.where(equipment: "Stability Ball").sample.url}", attachments: attachments, as_user: true)
 
 
elsif ["medicine ball"].any? { |w| event.formatted_text.starts_with? w } 
 client.chat_postMessage(channel: event.channel, text: "Do it because they said you couldn't!\n\n*#{Tool.all.where(equipment: "Medicine Ball").sample.workout_name}*\n#{Tool.all.where(equipment: "Medicine Ball").sample.url}", attachments: attachments, as_user: true)
 
 
elsif ["inspire"].any? { |w| event.formatted_text.starts_with? w } 
 client.chat_postMessage(channel: event.channel, text: "#{BodybuilderQuote.all.sample(1).first.quote}\n- #{BodybuilderQuote.all.sample(1).first.name}\n#{BodybuilderQuote.all.sample(1).first.photo_url}", attachments: attachments, as_user: true)
 
 
elsif ["before"].any? { |w| event.formatted_text.starts_with? w } 
 client.chat_postMessage(channel: event.channel, text: "*#{Beforeafter.all.sample(1).first.name}*\n- #{Beforeafter.all.sample(1).first.story}\n#{Beforeafter.all.sample(1).first.photo_url}", attachments: attachments, as_user: true)
 
 
elsif ["work"].any? { |w| event.formatted_text.starts_with? w } 
 client.chat_postMessage(channel: event.channel, text: "Yo dude! Here's a new workout video!\n*#{BodyPart.all.sample(1).first.workout_name}*\n#{BodyPart.all.sample(1).first.url}", attachments: attachments, as_user: true)
 

    # Handle the Help commands
  elsif event.formatted_text.include? "help"
    attachments =  intro
        client.chat_postMessage(channel: event.channel, text: "*Stuck, are we? Don't sweat it!*\n\n*Here are some tips!*\n\n- Type `/inspire` to be inspired by a smashing quote from an ultra famous celebrity bodybuilder you probably adore!\n- Type `/beforeafter` for inspiring before and after photos of famous bodybuilders!\n- Type `/workout` for a quick workout video handpicked by yours truly!\n- Type `help` if you're stuck!\n\n\n*Demand a workout video for any of the following by simply typing -*\n\n`shoulders` | `chest` | `back` | `abs` | `arms` | `glutes` | `legs`\n`dumbbells` | `kettle bell` | `barbell` | `stability ball` | `medicine ball`\n`interval training` | `pilates` | `yoga` | `tai chi` | `aerobics`\n", attachments: attachments, as_user: true)


  end 
end

# ----------------------------------------------------------------------  

def step_one
  
  [
      {
          "text": "How would you like to go about your workout today?",
          "callback_id": "step_one",
          "color": "#3AA3E3",
          "attachment_type": "default",
          "actions": [
              {
                  "name": "muscle_group",
                  "text": "Muscle Group",
                  "type": "button",
                  "value": "muscle_group"
              },
              {
                  "name": "equipment",
                  "text": "Equipment",
                  "type": "button",
                  "value": "equipment"
              },
              {
                  "name": "workout_type",
                  "text": "Workout Type",
                  "type": "button",
                  "value": "workout_type"
              }
          ]    
        }
    ].to_json   
end 

# ----------------------------------------------------------------------  

def intro
   [
        {
            markdwn: true,
            text: "If you want a more streamlined approach to your workout, start here!",
            "callback_id": "intro",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "start_workout",
                    "text": "Start Workout!",
                    "style": "primary",
                    "type": "button",
                    "value": "start_workout"
                }
            ]
        }
    ].to_json
end
#
# # ----------------------------------------------------------------------
#
def muscle_group

[
        {
            "text": "Which muscle group would you like to target?",
            "callback_id": "muscle_group",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "upper_body",
                    "text": "Upper Body",
                    "type": "button",
                    "value": "upper_body"
                },
                {
                    "name": "lower_body",
                    "text": "Lower Body",
                    "type": "button",
                    "value": "lower_body"
                }
            ]
          }
        ].to_json
end
#

# ----------------------------------------------------------------------

def lower_body

[
        {
            "text": "What's your pick?",
            "callback_id": "lower_body",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "glutes",
                    "text": "Glutes",
                    "type": "button",
                    "value": "glutes"
                },
                {
                    "name": "legs",
                    "text": "Legs",
                    "type": "button",
                    "value": "legs"
                }
            ]
          }
        ].to_json
end

# ----------------------------------------------------------------------

def upper_body

[
        {
            "text": "What's it going to be today?",
            "callback_id": "upper_body",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "shoulders",
                    "text": "Shoulders",
                    "type": "button",
                    "value": "shoulders"
                },
                {
                    "name": "chest",
                    "text": "Chest",
                    "type": "button",
                    "value": "chest"
                },
                {
                    "name": "back",
                    "text": "Back",
                    "type": "button",
                    "value": "back"
                },
                {
                    "name": "abs",
                    "text": "Abs",
                    "type": "button",
                    "value": "abs"
                },
                {
                    "name": "arms",
                    "text": "Arms",
                    "type": "button",
                    "value": "arms"
                }
            ]
          }
        ].to_json
end

# ----------------------------------------------------------------------

def equipment

[
        {
            "text": "What equipment would you like to use?",
            "callback_id": "equipment",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "dumbbells",
                    "text": "Dumbbells",
                    "type": "button",
                    "value": "dumbbells"
                },
                {
                    "name": "kettle_bell",
                    "text": "Kettle Bell",
                    "type": "button",
                    "value": "kettle_bell"
                },
                {
                    "name": "barbell",
                    "text": "Barbell",
                    "type": "button",
                    "value": "barbell"
                },
                {
                    "name": "stability_ball",
                    "text": "Stability Ball",
                    "type": "button",
                    "value": "stability_ball"
                },
                {
                    "name": "medicine_ball",
                    "text": "Medicine Ball",
                    "type": "button",
                    "value": "medicine_ball"
                }
            ]
        }
    ].to_json
end

# ----------------------------------------------------------------------

def workout_type

[
        {
            "text": "What workout type are you in the mood for?",
            "callback_id": "workout_type",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "hiit",
                    "text": "HIIT",
                    "type": "button",
                    "value": "hiit"
                },
                {
                    "name": "pilates",
                    "text": "Pilates",
                    "type": "button",
                    "value": "pilates"
                },
                {
                    "name": "yoga",
                    "text": "Yoga",
                    "type": "button",
                    "value": "yoga"
                },
                {
                    "name": "tai_chi",
                    "text": "Tai Chi",
                    "type": "button",
                    "value": "tai_chi"
                },
                {
                    "name": "aerobics",
                    "text": "Aerobics",
                    "type": "button",
                    "value": "aerobics"
                }
            ]
        }
    ].to_json
end

# ----------------------------------------------------------------------