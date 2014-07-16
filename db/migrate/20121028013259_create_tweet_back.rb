class CreateTweetBack < ActiveRecord::Migration
  def change
    create_table :tweet_backs do |t|
      t.string :tweet
      t.timestamps
    end
  end
end
