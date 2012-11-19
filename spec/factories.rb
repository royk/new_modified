FactoryGirl.define do
	sequence(:random_string) {|n| ('a'..'z').to_a.shuffle[0..9].join }

	factory :user, aliases: [:commenter] do
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
		uid  { generate(:random_string) }
		vendor "youtube"
		user
	end

	factory :notification do
	end		

	factory :comment do
		content "some comment"
		commenter
	end

	factory :like do
	end

end