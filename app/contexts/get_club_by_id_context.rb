# Context to retrieve a single loyalty card
#
# Author::    Shadley Wentzel

class GetClubByIdContext
  attr_reader :club_id

  def self.call(club_id)
    GetClubByIdContext.new(club_id).call
  end

  def initialize(club_id)
    @club_id = club_id
  end

  def call
    club = Club.find(@club_id)
    club.format_for_web_serivce
  end
end