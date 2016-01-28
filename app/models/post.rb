require 'pry'

class Post < ActiveRecord::Base

  def self.syndicate
    @posts = Post.all
    @posts.each do |post|
      # post.tweet
      #post.fbook
      # post.slack
      post.tumblr
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

  # def tumblr
  #   response = Unirest.post "api.tumblr.com/v2/blog/syndicator2/post",
  #                       headers:{ "Accept" => "application/json" },
  #                       parameters:{ :title => "test", :body => "test" }
  # end

# stapler = Staplegun.new :email => "evan.alexander.hawk@gmail.com", :password => "Syndicator"
#  stapler.pin {board_id: "110267959565564041", link:"http://imgur.com", image_url: "http://imgur.com/gallery/3ttnIn2.jpg", description: "Awesome!"}

# YouTubeIt::Client.new(:dev_key => "AIzaSyAeupAVAJrlfTDeuPkEhVSyVO9X6O7vxwk")
#
# Here is your client ID
# 419112315217-7ft9usomk83tnt63kb6hivt7ufr4siuv.apps.googleusercontent.com
# Here is your client secret
# qlSbIFxK5n3K9WJUmj5yJFEw
#
# client = YouTubeIt::OAuthClient.new("419112315217-7ft9usomk83tnt63kb6hivt7ufr4siuv.apps.googleusercontent.com", "qlSbIFxK5n3K9WJUmj5yJFEw", "UCKiw159ahYxZT0RNryTT3Rg", "AIzaSyAeupAVAJrlfTDeuPkEhVSyVO9X6O7vxwk")
# YouTubeIt::OAuthClient.new(:consumer_key => '419112315217-7ft9usomk83tnt63kb6hivt7ufr4siuv.apps.googleusercontent.com', :consumer_secret => 'qlSbIFxK5n3K9WJUmj5yJFEw', :dev_key => 'AIzaSyAeupAVAJrlfTDeuPkEhVSyVO9X6O7vxwk')
# client.add_comment(EX9NZ_mtZ0Q, "test comment!")

# client = YouTubeIt::Client.new(:dev_key => "AIzaSyAeupAVAJrlfTDeuPkEhVSyVO9X6O7vxwk")

end
