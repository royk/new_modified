# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
	before { @user = User.new(name: "Example User", email: "user@example.com",
		password: "foobar", password_confirmation: "foobar")}

	subject {@user}
	it {should respond_to(:name)}
	it {should respond_to{:email}}
	it {should respond_to(:password_digest)}
	it {should respond_to(:password_confirmation)}
	it {should respond_to(:authenticate) }
	it {should respond_to(:admin)}

end
