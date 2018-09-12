# Heroku Scheduler
# https://devcenter.heroku.com/articles/scheduler
namespace :heroku_scheduler do
  desc "Recalculate the hotness score of the story"
  task :recalculate_story_hotness_score => :environment do
    puts "Get the latest story from 5 days"
    stories = Story
      .where("created_at >= ?", 5.days.ago)

    stories.each do |story|
      prev_score = story.hotness
      story.hotness = story.hotness_score
      story.save!
      puts "Update hotness score story=" + story.short_id + " from=" + prev_score.to_s + " to=" + story.hotness.to_s
    end
  end

  desc "Tweet story on the front page"
  task :tweet_story => :environment do
    puts "Get the story from the front page"
    story = Story
      .order(:hotness => :desc)
      .where(:twitter_id => nil)
      .where("created_at >= ?", 2.days.ago)
      .first
    if story.nil?
      puts "Skip tweeting ..."
    end

    # Tweet the story
    tags = story.tags.pluck(:tag).map {|t| ' #' + t }.join('')
    via = ""
    if story.user.twitter_username.present?
      via = "\n" +
            (s.user_is_author? ? "by" : "via") +
            " @#{s.user.twitter_username}"
    end
    tco_status = via +
                 "\n" +
                 ("X" * Twitter::TCO_LEN) + tags +
                 (story.url.present? ? "\n" + ("X" * Twitter::TCO_LEN) : "")

    status = via +
             "\n" +
             story.short_id_url +
             tags +
             (story.url.present? ? "\n" + story.url : "")

    left_len = Twitter::MAX_TWEET_LEN - tco_status.length

    title = story.title
    if title.match?(/^([dm] |@)/i)
      # prevent these tweets from activating twitter shortcuts
      # https://dev.twitter.com/docs/faq#tweeting
      title = "- #{title}"
    end

    # if there are any urls in the title, they should be sized (at least) to a
    # twitter t.co url
    left_len -= title.scan(/[^ ]\.[a-z]{2,10}/i)
                     .map {|_u| [0, Twitter::TCO_LEN].max }
                     .inject(:+)
                     .to_i

    if left_len < -3
      left_len = -3
    end

    if title.bytesize > left_len
      status = title[0, left_len - 3] + "..." + status
    else
      status = title + status
    end

    # Twitter is from /extras/twitter.rb
    res = Twitter.oauth_request("/1.1/statuses/update.json",
                                :post,
                                "status" => status)

    begin
      if res["id_str"].to_s.match?(/\d+/)
        story.update_column("twitter_id", res["id_str"])
        puts "Tweet story #{story.id}"
      elsif res["errors"].select {|e| e["code"] == 226 || e["code"] == 186 }.any?
        # twitter is rejecting the content of this message, skip it
        story.update_column("twitter_id", 0)
        puts "skipping: failed posting story #{story.id} (#{status.inspect}): #{res.inspect}\n"
      else
        raise
      end
    rescue => e
      puts "failed posting story #{story.id} (#{status.inspect}): #{e.inspect}\n#{res.inspect}"
      exit
    end
  end
end
