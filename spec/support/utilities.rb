def make_signed_in_admin(_user)
	sign_out
	_user.admin = true
	_user.save!
	sign_in _user
end


def sign_in(_user)
	if @signed_in
		sign_out
	end
	visit signin_path
	fill_in "Email",	with: _user.email
	fill_in "Password", with: _user.password
	click_button "Sign in"
	cookies[:remember_token] = _user.remember_token
	@signed_in = true
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
	if @signed_in
		visit root_path
		page.find(:xpath, "//a[@href='/signout']").click
		cookies.permanent[:remember_token] = nil
		@signed_in = false
	end
end
