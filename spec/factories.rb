FactoryGirl.define do
	sequence(:random_string) {|n| ('a'..'z').to_a.shuffle[0..9].join }

	factory :user, aliases: [:commenter, :liker, :sender, :recipient] do
		sequence(:name)  { |n| "Person #{n}" }
		sequence(:modified_user)  { |n| "Person #{n}" }
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
		url  "http://vimeo.com/53369314"
		uid  { generate(:random_string) }
		vendor "youtube"
		public {true}
		user
	end

	factory :notification do
	end		

	factory :comment do
		content "some comment"
		commenter
	end

	factory :like do
		liker
		liked_item {create(:video)}
	end

	factory :blog do
		user
	end

	factory :blog_post do
		blog
		content "Some blog"
	end

	factory :message do
		content "some message"
		sender
	end

	factory :page do
		content "i am a page"
		name "hello"
	end

	factory :article do
		content "i am an article"
		title "Title"
		user
	end

	factory :category do
		name "Some Category"
	end

	factory :feed do
		name "Some feed"
		permalink "my_permalink"
	end

	factory :event do
		name "Some Event"
		start_date Time.now
		end_date Time.now + 5.days
	end

end