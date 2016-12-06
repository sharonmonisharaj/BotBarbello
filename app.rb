require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'rake'
require 'slack-ruby-client'
require 'httparty'
require 'rainbow'
# ----------------------------------------------------------------------

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end

# require any models 
# you add to the folder
# using the following syntax:


require_relative 'app'
require_relative './models/dumbbell_exercise'
require_relative './models/barbell_exercise'
require_relative './models/cardio_exercise'


# enable sessions for this project
enable :sessions

# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

get "/" do
  401
end

# ----------------------------------------------------------------------

get "/login/:user" do 
  
  #send_slack_request "Good news\n #{params[:user]} just signed into the app." 
  
  send_slack_request "Good news\n #{params[:user]} just signed into the app.", ["https://github.com/daraghbyrne"]
  
end 

# check for token = 2JWqGx57O5oZXPCye5cOX4kz

# Params I'll receive
# token=2JWqGx57O5oZXPCye5cOX4kz
# team_id=T0001
# team_domain=example
# channel_id=C2147483705
# channel_name=test
# user_id=U2147483697
# user_name=Steve
# command=/weather
# text=94070
# response_url=https://hooks.slack.com/commands/1234/5678

# ----------------------------------------------------------------------
#     SLASH COMMANDS
# ----------------------------------------------------------------------

post "/workout"  do
  
  puts params.to_s

  slack_token = "X5Xu7haqc2oBLZLSZBhs8hIS"

  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]

    
    greeting = ["Hey dude!", "Hey man!", "Hey brother!", "It's great to see you bro!"]
    
     if text.downcase.strip == "dumbbell"{
       random = DumbbellExercise.all.sample(1).first
       formatted_message = greeting.sample + " I've been asked to get a #{text} workout"
     }
     
     elsif text.downcase.strip == "barbell"{
       random = BarbellExercise.all.sample(1).first
       formatted_message = greeting.sample + " I've been asked to get a #{text} workout"
     }
     
     elsif text.downcase.strip == "cardio"{
       random = CardioExercise.all.sample(1).first
       formatted_message = greeting.sample + " I've been asked to get a #{text} workout"
     }  
     
   else {
     "I'm sorry, it looks like I can't help you with that at the moment. Please enter one of the following\n\n/workout dumbbell\n/workout barbell\n/workout cardio"
   }

    content_type :json
  
    {text: formatted_message, response_type: "in_channel" }.to_json

  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end
  
  
end

post "/dumbbell_slash_cmd/" do

  puts params.to_s

  slack_token = "X5Xu7haqc2oBLZLSZBhs8hIS"

  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]


    if text.downcase.strip == "cardio"
      # send back a cardio workout
    elsif text.downcase.strip == "barbell"
      # ...
      # ...
      # ..
    end  
    
    greeting = ["Hey dude!", "Hey man!", "Hey brother!", "It's great to see you bro!"]
    
    random = DumbbellExercise.all.sample(1).first
    formatted_message = greeting.sample + " Here's your new dumbbell workout video!\n\n" + Rainbow(random.name).underline + "\n" + random.dumbbell

    content_type :json
  
    {text: formatted_message, response_type: "in_channel" }.to_json

  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end

end

# ----------------------------------------------------------------------

post "/barbell_slash_cmd/" do

  puts params.to_s

  slack_token = "4hJ7uwXro4ChP43cUV6LJc1W"

  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]

    
    greeting = ["Hey dude!", "Hey man!", "Hey brother!", "It's great to see you bro!"]
    
    random = BarbellExercise.all.sample(1).first
    formatted_message = greeting.sample + " Here's your new barbell workout video!\n\n" + Rainbow(random.name).underline + "\n" + random.barbell

    content_type :json
  
    {text: formatted_message, response_type: "in_channel" }.to_json

  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end

end

# ----------------------------------------------------------------------

post "/cardio_slash_cmd/" do

  puts params.to_s

  slack_token = "QRguIojaAvbSaXaK5IYFcuCC"

  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]

    
    greeting = ["Hey dude!", "Hey man!", "Hey brother!", "It's great to see you bro!"]
    
    random = CardioExercise.all.sample(1).first
    formatted_message = greeting.sample + " Here's your new cardio workout video!\n\n" + Rainbow(random.name).underline + "\n" + random.cardio

    content_type :json
  
    {text: formatted_message, response_type: "in_channel" }.to_json

  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end

end

# ----------------------------------------------------------------------
#     OUTGOING WEBHOOK
# ----------------------------------------------------------------------
post "/botbarbello_outgoing/" do
   content_type :json
   {text: "Hi! I'm BotBarbello. I'm here to empower you with a new high energy body-building workout video everyday! Building a stronger you is my life's only goal.\n\nHere's how you can make the best use of me with slash commands:\n\nSimply type any of the following into a channel of your choice:\n\n/dumbbell\n/barbell\n/cardio\n/abs\n\nFor help, simply type the word 'help'.", response_type: "in channel" }.to_json
end

# ----------------------------------------------------------------------
#     ERRORS
# ----------------------------------------------------------------------

error 401 do 
  "Whoops! Not allowed!!!"
end

# ----------------------------------------------------------------------
#   METHODS
#   Add any custom methods below
# ----------------------------------------------------------------------

private


#"https://hooks.slack.com/services/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"
#payload

# You have two options for sending data to the Webhook URL above:
# Send a JSON string as the payload parameter in a POST request
# Send a JSON string as the body of a POST request
# For a simple message, your JSON payload could contain a text property at minimum. This is the text that will be posted to the channel.
# A simple example:
# payload={"text": "This is a line of text in a channel.\nAnd this is another line of text."}


# for example 
def send_slack_request message

  slack_webhook = "https://hooks.slack.com/services/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"
  
  HTTParty.post slack_webhook, body: { text: message.to_s, username: "AppBot", channel: "bots"}.to_json, headers: {'content-type' => 'application/json'}

  response
  
end

#
# def send_slack_request message, links
#
#   slack_webhook = "https://hooks.slack.com/services/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"
#
#   formatted_message = message.to_s + "\n"
#   links.each do |link|
#     formatted_message += "<#{link.to_s}>".to_s
#   end
#
#   HTTParty.post slack_webhook, body: {text: formatted_message.to_s, username: "AppBot", channel: "bots"}.to_json, headers: {'content-type' => 'application/json'}
#
#   response
#
# end


# -----------------------------------------------------------------
#     TO DO
# -----------------------------------------------------------------

# Connect to YouTube API to retrieve workout video URLs based on keywords entered

# Connect to Slack API to  to improve efficiency of outgoing webhooks 

# Add custom integrations to a slack app

# Add outgoing webhooks to retrieve specific workout videos from the database

# Restrict to certain YouTube Channel

# Male or female? settings

# Microformating in slack