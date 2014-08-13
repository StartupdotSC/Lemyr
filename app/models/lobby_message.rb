class LobbyMessage < ActiveRecord::Base
  attr_accessible :text

  def to_s
    "Message"
  end
end
