def sign_in(user)
	visit signin_path
	fill_in "Email",	with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
	cookies[:remember_token] = user.remember_token
end

def sign_up(user)
	visit signup_path
	
	fill_in "user_email",	with: user.email
	fill_in "user_name",	with: user.name
	fill_in "Password", with: user.password
	fill_in "Confirmation", with: user.password
	click_button "Create my account"
	cookies[:remember_token] = user.remember_token
end

def sign_out
	click_button "signout"
end
