def sign_in(_user)
	visit signin_path
	fill_in "Email",	with: _user.email
	fill_in "Password", with: _user.password
	click_button "Sign in"
	cookies[:remember_token] = _user.remember_token
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

def sign_out_2
	visit root_path
	page.find(:xpath, "//a[@href='/signout']").click
	cookies.permanent[:remember_token] = nil
end
