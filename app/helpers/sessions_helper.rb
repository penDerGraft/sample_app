module SessionsHelper
	def sign_in(user)
		#create new remember token
    remember_token = User.new_remember_token
    #store raw token in cookies
    cookies.permanent[:remember_token] = remember_token
    #update attribute in db
    user.update_attribute(:remember_token, User.digest(remember_token))
    #make current user the given user
    self.current_user = user 
	end
	
	def current_user=(user)
	  @current_user = user
  end

  def current_user
		remember_token = User.digest(cookies[:remember_token])
		#same as += or *= "if current user not nil, set value
		@current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def signed_in?
  	 !current_user.nil?
  end
  
  def sign_out
		current_user.update_attribute(:remember_token,
																	User.digest(User.new_remember_token))
  	cookies.delete(:remember_token)
  	self.current_user = nil
  end
end
