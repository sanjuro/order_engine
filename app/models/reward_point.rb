# Class to model the level of reward points
#
# Author::    Shadley Wentzel
class RewardPoint < ActiveRecord::Base
	attr_accessible :user_id, :total_points, :is_current

	belongs_to :user

  	scope :by_user, lambda {|user_id| where("reward_points.user_id = ?", user_id)} 
 	scope :current_level, where("reward_points.is_current = 1")

	def current_point_total(user_id)
	    current_reward_point_level = RewardPoint.current_level.by_user!(user_id)
	    current_reward_point_level.total_points
	end   
	  
	def decrease_points(user_id, total_points)
	    order_item_usage = order_item.quantity * order_item.billing_price
	    	    
	    new_reward_points_level = RewardPoint.current_point_total(user_id) - total_points
	    
	    reward_point_level = RewardPoint.new(:user_id => user_id,
	                                      :total_points => new_reward_points_level,
	                                      :is_current => 1,
	                                      :created_at => Time.zone.now                         
	                                      )
	    reward_point_level.save
	    	    
	    current_reward_point_level.update_attributes_without_callbacks({
	      :is_current => 0
	    }) 	     
    end   
end