# Class to model the tag resource
#
# Author::    Shadley Wentzel

class Tag < ActiveRecord::Base
    attr_accessible :name
end