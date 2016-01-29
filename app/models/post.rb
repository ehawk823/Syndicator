require 'pry'

class Post < ActiveRecord::Base
  validates_presence_of :title, :short_desc, :full_desc, :price
  validates :price,    :numericality => true
  validates :phone,    :numericality => true
  validates :phone,    length: { is: 10 }

# Calls posting methods on all newly created posts and then sets each post's is_new value to false

  def self.syndicate
    @posts = Post.all
    @posts.each do |post|
      if post.is_new == true
          post.tweet
          post.fbook
          post.slack
          post.tumblr
          post.twilio
      end
      post.is_new = false
      post.save
    end
  end

# Sets client and sends tweet to my twitter account

  def tweet
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]
      config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"]
      config.access_token        = ENV["YOUR_ACCESS_TOKEN"]
      config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]
    end
    if self.title != nil
      client.update("#{self.title} - #{self.short_desc} ($#{self.price})")
    end
  end

# Uses Koala gem to send post to my facebook account

  def fbook
    @user = Koala::Facebook::API.new(ENV["ACCESS_TOKEN"])
    if self.title != nil
      @user.put_connections("me", "feed", :message => "#{self.title} - #{self.short_desc} ($#{self.price})")
    end
  end

#Uses notifier gem to send post to specified slack channel

  def slack
    notifier = Slack::Notifier.new ENV["WEB_HOOK"], channel: '#general', username: 'notifier'
    if self.title != nil
      notifier.ping "#{self.title} - #{self.full_desc} ($#{self.price})"
    end
  end

# Sets tumblr client and send post to my tumblr account

  def tumblr
    client = Tumblr::Client.new({
      :consumer_key => ENV['OAUTH_CONSUMER_KEY'],
      :consumer_secret => ENV['SECRET_KEY'],
      :oauth_token => ENV['OAUTH_TOKEN'],
      :oauth_token_secret => ENV['OAUTH_TOKEN_SECRET']
    })
    client.text("syndicator2", :title => "#{self.title}", :body => "#{self.full_desc}")
  end

# Sends text with twilio to the number specified when the post was created

  def twilio
    account_sid = ENV["TWILIO_SID"]
    auth_token = ENV['TWILIO_TOKEN']
    client = Twilio::REST::Client.new account_sid, auth_token

    from = "8452633595"

      client.account.messages.create(
        :from => from,
        :to => self.phone,
        :body => "#{self.title} - #{self.full_desc} ($#{self.price})"
      )
      puts "Sent message"
  end

end
