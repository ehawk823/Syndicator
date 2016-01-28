require 'pry'

class Post < ActiveRecord::Base

  def self.syndicate
    @posts = Post.all
    @posts.each do |post|
      post.tweet
      post.fbook
      post.slack
      post.tumblr
      post.twilio
    end
  end

  def tweet
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]
      config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"]
      config.access_token        = ENV["YOUR_ACCESS_TOKEN"]
      config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]
    end
    if self.title != nil
      client.update("#{self.title}")
    end
  end

  def fbook
    @user = Koala::Facebook::API.new(ENV["ACCESS_TOKEN"])
    if self.title != nil
      @user.put_connections("me", "feed", :message => "#{self.title}")
    end
  end

  def slack
    notifier = Slack::Notifier.new ENV["WEB_HOOK"], channel: '#3-musketeers', username: 'notifier'
    if self.title != nil
      notifier.ping "#{self.title}"
    end
  end


  def tumblr
    client = Tumblr::Client.new({
      :consumer_key => ENV['OAUTH_CONSUMER_KEY'],
      :consumer_secret => ENV['SECRET_KEY'],
      :oauth_token => ENV['OAUTH_TOKEN'],
      :oauth_token_secret => ENV['OAUTH_TOKEN_SECRET']
    })
    client.text("syndicator2", :title => "trial", :body => "trial")
  end

  def twilio
    account_sid = ENV["TWILIO_SID"]
    auth_token = ENV['TWILIO_TOKEN']
    client = Twilio::REST::Client.new account_sid, auth_token

    from = "8452633595"

      client.account.messages.create(
        :from => from,
        :to => '8455969475',
        :body => "Hey, party at 6PM!"
      )
      puts "Sent message"
  end

end
