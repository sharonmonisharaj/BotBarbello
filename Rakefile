# require your app file first
require './app'
require 'sinatra/activerecord/rake'

desc "This task is called by the Heroku scheduler add-on"

task :send_inspiring_quote do

  slack_webhook = "https://hooks.slack.com/services/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"

  random = BodybuilderQuote.all.sample(1).first
  message = random.quote + "\n*- #{random.name}*"

  HTTParty.post slack_webhook, body: {text: message.to_s, username: "BotBarbello", channel: "fitness"}.to_json, headers: {'content-type' => 'application/json'}

  response

end