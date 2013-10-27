# Class to model the user stores resource
#
# Author::    Shadley Wentzel
class DealUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :deal
end