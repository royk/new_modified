FactoryGirl.define do 
	factory :user do
		sequence(:name)  { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com"}   
		password "fafafa"
		password_confirmation "fafafa"
	end

	factory :admin do
		admin true
	end

	factory :post do
		content "lalala"
		user
	end

	factory :video do
		title "some title"
		url "http://www.youtube.com/watch?feature=player_embedded&v=svDPNjQV3ak"
		user
	end
end