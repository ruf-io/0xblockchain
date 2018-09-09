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
  end
end
