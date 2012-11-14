namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_videos
	end
end

def make_users
	admin = User.create!(	name: "Example User",
					email: "example@railstutorial.org",
					password: "foobar",
					password_confirmation: "foobar")
	admin.toggle!(:admin)
	99.times do |n|
		name = Faker::Name.name
		email = "examle-#{n+1}@rails.org"
		password = "password"
		User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
	end
end

def make_videos
	users = User.all(limit:5)
	20.times do |n|
		users.each do |user|
			title = "Video #{n+1}"
			vendor = n%2==0 ? "youtube" : "vimeo"
			uid = (('a'..'z').to_a + (0..9).to_a).shuffle[0..9].join
			user.videos.create!(	title: title,
							vendor: vendor,
							uid: 	uid) 
		end
	end
end
