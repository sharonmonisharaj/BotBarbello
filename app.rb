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


# enable sessions for this project
enable :sessions

# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

get "/" do
  401
end



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

# sample cURL request for incoming webhook to be entered in the Terminal
# curl -X POST --data-urlencode 'payload={"channel": "#general", "username": "MotivaBot", "text": "This is posted to #general and comes from a bot named MotivaBot."}' https://hooks.slack.com/services/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

post "/handle_echo_slash_cmd/" do


  puts params.to_s

  # this should be in a .env
  slack_token = "YViiD19u9idrtQkfozXMriDc"

  # check it's valid
  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]
    
    #formatted_message = "@#{user_name} said:\n" + text.to_s 
    
    random = MotivationalQuote.all.sample(1).first
    formatted_message = random.quote
    
    #formatted_message = "You're the best!!!"
        
    #echo_slack_request response_url, channel_name, user_name, text
    #{text: formatted_message, response_type: "in_channel" }.to_json

    # specify the return type as 
    # json
    content_type :json
    
    # When the response_type is in_channel, both the response message and the initial message typed by the user will be shared in the channel. 

    # Setting response_type to ephemeral is the same as not including the response type at all, and the response message will be visible only to the user that issued the command. For the best clarity of intent, we recommend always declaring your intended response_type.

    {text: formatted_message, response_type: "in_channel" }.to_json
    
    
  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end

end

# ----------------------------------------------------------------------

post "/dumbbell_slash_cmd/" do


  puts params.to_s

  # this should be in a .env
  slack_token = "X5Xu7haqc2oBLZLSZBhs8hIS"

  # check it's valid
  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]
    
    #formatted_message = "@#{user_name} said:\n" + text.to_s 
    
    greeting = ["Hey dude!", "Hey man!", "Hey brother!", "It's great to see you bro!"]
    
    random = DumbbellExercise.all.sample(1).first
    formatted_message = puts greeting.sample + " Here's your new dumbbell workout video!\n\n" + Rainbow(random.name).underline + "\n" + random.dumbbell
    
    #formatted_message = "You're the best!!!"
        
    #echo_slack_request response_url, channel_name, user_name, text
    #{text: formatted_message, response_type: "in_channel" }.to_json

    # specify the return type as 
    # json
    content_type :json
    
    # When the response_type is in_channel, both the response message and the initial message typed by the user will be shared in the channel. 

    # Setting response_type to ephemeral is the same as not including the response type at all, and the response message will be visible only to the user that issued the command. For the best clarity of intent, we recommend always declaring your intended response_type.

    {text: formatted_message, response_type: "in_channel" }.to_json
    
    
  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end

end


# ----------------------------------------------------------------------
#     OUTGOING WEBHOOK
# ----------------------------------------------------------------------
post "/outgoing/" do
   content_type :json
   {text: "Hi! I'm BotBarbello. I'm here to empower you with a new high energy body-building workout video everyday! Building a stronger you is my life's only goal.", response_type: "in channel" }.to_json
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