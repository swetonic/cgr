
class NoPercPoint < ActiveRecord::Base
  
  def self.users_and_points
    users_points = {}
    points = find(:all, :group => 'user_id', :select => 'sum(points), user_id')
    points.each do |pt|
      begin
        user = User.find(pt.user_id)
        unless user.nil?
          users_points[user] = pt.attributes['sum(points)']
        end
      rescue
      end
    end
    users_points
  end
  
  def self.add_points(user, points, reason, order_id=nil)
    points = create(:user_id => user.id, :points => points, 
            :reason => reason, :order_id => order_id)
    points.save!
  end
  
end
