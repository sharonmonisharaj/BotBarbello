# require your app file first
require './app'
require 'sinatra/activerecord/rake'

desc "This task is called by the Heroku scheduler add-on"

task :send_motivational_quote do

  slack_webhook = "https://hooks.slack.com/services/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"

  random = MotivationalQuote.all.sample(1).first
  message = random.quote

  HTTParty.post slack_webhook, body: {text: message.to_s, username: "MotivaBot", channel: "test"}.to_json, headers: {'content-type' => 'application/json'}

  response

end