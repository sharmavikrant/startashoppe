class Masterusers < ActiveRecord::Base
attr_accessible  :master_user_id,:url_name,:password,:shop_name,:first_name,:last_name,:address,:landmark,:city,:state,:pincode,:country,:phone,:master_email,:validate,:theam 
end
