# Class to model the customer stores resource
#
# Author::    Shadley Wentzel
class UserStore < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
end