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
  
  if call_back == "hello_buttons"
    
    replace_message = "Thanks for your selection."
    
    puts "found match "
    if action_name == "muscle_group"

      replace_message += "What are you in the mood for?"
      attachments =  muscle_group 
      client.chat_postMessage(channel: channel, text: "Yo dude!", attachments: attachments, as_user: true)

      client.chat_postMessage(channel: channel, text: "You chose muscle_group.", as_user: true)
        
    elsif action_name == "equipment"
      replace_message += "Here's a equipmentworkout."

      client.chat_postMessage(channel: channel, text: "You chose muscle_group.", as_user: true)
      
    elsif action_name == "workout_type"
      replace_message += "Here's a workout type workout."

      client.chat_postMessage(channel: channel, text: "You chose muscle_group.", as_user: true)
      
    else
      replace_message += "Here's a something else workout."

      client.chat_postMessage(channel: channel, text: "You chose muscle_group.", as_user: true)
    
    end

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
       random = DumbbellExercise.all.sample(1).first
       formatted_message = greeting.sample + " Here's your new dumbbell workout video!\n\n" + random.name + "\n" + random.dumbbell
     
     
     elsif text.downcase.strip == "barbell"
       random = BarbellExercise.all.sample(1).first
       formatted_message = greeting.sample + " Here's your new barbell workout video!\n\n" + random.name + "\n" + random.barbell
    
     
     elsif text.downcase.strip == "cardio"
       random = CardioExercise.all.sample(1).first
       formatted_message = greeting.sample + " Here's your new cardio workout video!\n\n" + random.name + "\n" + random.cardio
  
   else 
     "I'm sorry, it looks like I can't help you with that at the moment. Please enter one of the following\n\n/workout dumbbell\n/workout barbell\n/workout cardio"
   end

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
  
  # Hi Commands
  if ["hi", "hey", "hello"].any? { |w| event.formatted_text.starts_with? w }  
    attachments =  get_hello_buttons 
    client.chat_postMessage(channel: event.channel, text: "Yo dude!", attachments: attachments, as_user: true)

  elsif ["muscle group"].any? { |w| event.formatted_text.starts_with? w }  
    attachments =  muscle_group 
    client.chat_postMessage(channel: event.channel, text: "Hey man!", attachments: attachments, as_user: true)

  elsif ["upper body"].any? { |w| event.formatted_text.starts_with? w }  
    attachments =  upper_body 
    client.chat_postMessage(channel: event.channel, text: "Hey bro!", attachments: attachments, as_user: true)

  elsif ["lower body"].any? { |w| event.formatted_text.starts_with? w }  
    attachments =  lower_body 
    client.chat_postMessage(channel: event.channel, text: "Yo!", attachments: attachments, as_user: true)

    # Handle the Help commands
  elsif event.formatted_text.include? "help"
    attachments =  intro
    client.chat_postMessage(channel: event.channel, text: "Hey hey hey!", attachments: attachments, as_user: true)


  end 
end

# ----------------------------------------------------------------------  

def get_hello_buttons
  
  [
      {
          "text": "How would you like to go about your workout today?",
          "fallback": "You are unable to choose a game",
          "callback_id": "hello_buttons",
          "color": "#3AA3E3",
          "attachment_type": "default",
          "actions": [
              {
                  "name": "muscle_group",
                  "text": "Body Part",
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
              },
              {
                  "name": "war",
                  "text": "You decide!",
                  "style": "danger",
                  "type": "button",
                  "value": "war",
                  "confirm": {
                      "title": "I'd be happy to pick for you bro!",
                      "text": "Don't you have anything in mind though?",
                      "ok_text": "Yes",
                      "dismiss_text": "No"
                  }
          
              }
          ]    
        }
    ].to_json   
end 

# ----------------------------------------------------------------------  

def intro
   [
        {
            "mrkdwn": true,
            "text": "I'm BotBarbello, your fitness buddy! We're going to have a blast!\n\nHere's the lingo I understand brother -\n\n\nType /inspire to be inspired by a smashing quote from an ultra famous celebrity bodybuilder you probably adore!\n\n\n--------------------\n\n\nType /workout followed by cardio, dumbbell or barbell for a quick workout video belonging to that category.\n\n\n--------------------\n\n\nYou can also ask me for a video on any of the following by simply typing -\nshoulders\nchest\nback\nabs\narms\nglutes\nlegs\n\n\n--------------------\n\n\nIf you want a more streamlined approach to your workout, start here!",
            "callback_id": "intro",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "start_workout",
                    "text": "Start Workout!",
                    "style": "danger",
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
# def step_one
#
# [
#         {
#             "text": "How would you like to go about your workout today?",
#             "callback_id": "step_one",
#             "color": "#3AA3E3",
#             "attachment_type": "default",
#             "actions": [
#                 {
#                     "name": "muscle_group",
#                     "text": "Muscle Group",
#                     "type": "button",
#                     "value": "muscle_group"
#                 },
#                 {
#                     "name": "equipment",
#                     "text": "Equipment",
#                     "type": "button",
#                     "value": "equipment"
#                 },
#                 {
#                     "name": "workout_type",
#                     "text": "Workout Type",
#                     "type": "button",
#                     "value": "workout_type"
#                 }
#             ]
#         }
#     ].to_json
# end
#
# # # ----------------------------------------------------------------------
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

# # # ----------------------------------------------------------------------

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

# # # ----------------------------------------------------------------------

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

# # # ----------------------------------------------------------------------
#
# def equipment
#
# [
#         {
#             "text": "What equipment would you like to use?",
#             "callback_id": "equipment",
#             "color": "#3AA3E3",
#             "attachment_type": "default",
#             "actions": [
#                 {
#                     "name": "dumbbells",
#                     "text": "Dumbbells",
#                     "type": "button",
#                     "value": "dumbbells"
#                 },
#                 {
#                     "name": "kettle_bell",
#                     "text": "Kettle Bell",
#                     "type": "button",
#                     "value": "kettle_bell"
#                 },
#                 {
#                     "name": "barbell",
#                     "text": "Barbell",
#                     "type": "button",
#                     "value": "barbell"
#                 },
#                 {
#                     "name": "pull_up_bar",
#                     "text": "Pull Up Bar",
#                     "type": "button",
#                     "value": "pull_up_bar"
#                 },
#                 {
#                     "name": "rings",
#                     "text": "Rings",
#                     "type": "button",
#                     "value": "rings"
#                 },
#                 {
#                     "name": "jump_rope",
#                     "text": "Jump Rope",
#                     "type": "button",
#                     "value": "jump_rope"
#                 },
#                 {
#                     "name": "plyo_box",
#                     "text": "Plyo Box",
#                     "type": "button",
#                     "value": "plyo_box"
#                 },
#                 {
#                     "name": "stability_ball",
#                     "text": "Stability Ball",
#                     "type": "button",
#                     "value": "stability_ball"
#                 },
#                 {
#                     "name": "medicine_ball",
#                     "text": "Medicine Ball",
#                     "type": "button",
#                     "value": "medicine_ball"
#                 },
#                 {
#                     "name": "bosu_ball",
#                     "text": "Bosu Ball",
#                     "type": "button",
#                     "value": "bosu_ball"
#                 }
#             ]
#         }
#     ].to_json
# end
#
# # # ----------------------------------------------------------------------
#
# def workout_type
#
# [
#         {
#             "text": "What workout type are you in the mood for?",
#             "callback_id": "workout_type",
#             "color": "#3AA3E3",
#             "attachment_type": "default",
#             "actions": [
#                 {
#                     "name": "hiit",
#                     "text": "HIIT",
#                     "type": "button",
#                     "value": "hiit"
#                 },
#                 {
#                     "name": "pilates",
#                     "text": "Pilates",
#                     "type": "button",
#                     "value": "pilates"
#                 },
#                 {
#                     "name": "yoga",
#                     "text": "Yoga",
#                     "type": "button",
#                     "value": "yoga"
#                 },
#                 {
#                     "name": "tai_chi",
#                     "text": "Tai Chi",
#                     "type": "button",
#                     "value": "tai_chi"
#                 },
#                 {
#                     "name": "zumba",
#                     "text": "Zumba",
#                     "type": "button",
#                     "value": "zumba"
#                 },
#                 {
#                     "name": "aerobics",
#                     "text": "Aerobics",
#                     "type": "button",
#                     "value": "aerobics"
#                 }
#             ]
#         }
#     ].to_json
# end

# # ----------------------------------------------------------------------