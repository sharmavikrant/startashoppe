class MetawingController < ApplicationController
	def sms
	if params[:submit]=='Send Message' then 
		                       
			@a=params[:Phone].split(" ");
			@length=@a.length
			i=0;
			while i<@a.length 		
				@a[i]=@a[i].gsub(',',"");
				i=i+1
			end
			 Exotel.configure do |c|
                        c.exotel_sid   = "ticnpic"
                        c.exotel_token = "eebefc90f3134bb40ab892ceb6d8eba2c0ce931f"
             end
			@a.each do |i|
			begin	
				response = Exotel::Sms.send(:from => '01203843159', :to => "#{i}", :body => "#{params[:message]}")
			rescue
			end
			end
			flash[:notice] = "Message has been sent"
		end 

	end 







end
