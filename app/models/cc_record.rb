
class CcRecord < ActiveRecord::Base
  belongs_to :user

  def self.find_by_user_id(user_id)
    find(:first, :conditions => "user_id=#{user_id}")
  end

  def validate_on_update
    if cc.empty? or cvv.empty? or expiration.empty?
      raise "Credit card number, cvv code and expiration must be filled in."
    end
  end

end
