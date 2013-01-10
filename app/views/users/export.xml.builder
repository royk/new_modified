xml.instruct!
xml.tag!("ss:Workbook", :'xmlns:ss' => "urn:schemas-microsoft-com:office:spreadsheet") do
	xml.tag!("ss:Worksheet", :"ss:Name"=>"Sheet2") do
		xml.tag!("ss:Table") do
			xml.tag!("ss:Row") do
				User.column_names.each do |c|
					xml.tag!("ss:Cell") do
						xml.tag!("ss:Data", c, :"ss:Type"=>"String")
					end
				end
			end
			xml.tag! "ss:Row" do
				User.column_names.each do |c|
					xml.tag!("ss:Cell") do
						xml.tag!("ss:Data", current_user.attributes.values_at(*c), :"ss:Type"=>"String")
					end
				end
			end
			xml.tag! "ss:Row" do
				xml.tag! "ss:Cell" do
					xml.tag!("ss:Data", "Posts", :"ss:Type"=>"String")
				end
			end
			if current_user.posts.any?
				xml.tag! "ss:Row" do
					Post.column_names.each do |c|
						xml.tag!("ss:Cell") do
							xml.tag!("ss:Data", c, :"ss:Type"=>"String")
						end
					end
				end
				current_user.posts.each do |post|
					xml.tag! "ss:Row" do
						Post.column_names.each do |c|
							xml.tag!("ss:Cell") do
								xml.tag!("ss:Data", post.attributes.values_at(*c), :"ss:Type"=>"String")
							end
						end
					end
				end
			end
			xml.tag! "ss:Row" do
				xml.tag! "ss:Cell" do
					xml.tag!("ss:Data", "Articles", :"ss:Type"=>"String")
				end
			end
			if current_user.articles.any?
				xml.tag! "ss:Row" do
					Article.column_names.each do |c|
						xml.tag!("ss:Cell") do
							xml.tag!("ss:Data", c, :"ss:Type"=>"String")
						end
					end
				end
				current_user.articles.each do |article|
					xml.tag! "ss:Row" do
						Post.column_names.each do |c|
							xml.tag!("ss:Cell") do
								xml.tag!("ss:Data", article.attributes.values_at(*c), :"ss:Type"=>"String")
							end
						end
					end
				end
			end
			xml.tag! "ss:Row" do
				xml.tag! "ss:Cell" do
					xml.tag!("ss:Data", "Videos", :"ss:Type"=>"String")
				end
			end
			if current_user.videos.any?
				xml.tag! "ss:Row" do
					Video.column_names.each do |c|
						xml.tag!("ss:Cell") do
							xml.tag!("ss:Data", c, :"ss:Type"=>"String")
						end
					end
				end
				current_user.videos.each do |video|
					xml.tag! "ss:Row" do
						Video.column_names.each do |c|
							xml.tag!("ss:Cell") do
								xml.tag!("ss:Data", video.attributes.values_at(*c), :"ss:Type"=>"String")
							end
						end
					end
				end
			end
			xml.tag! "ss:Row" do
				xml.tag! "ss:Cell" do
					xml.tag!("ss:Data", "Comments", :"ss:Type"=>"String")
				end
			end
			if current_user.comments.any?
				xml.tag! "ss:Row" do
					Comment.column_names.each do |c|
						xml.tag!("ss:Cell") do
							xml.tag!("ss:Data", c, :"ss:Type"=>"String")
						end
					end
				end
				current_user.comments.each do |comment|
					xml.tag! "ss:Row" do
						Comment.column_names.each do |c|
							xml.tag!("ss:Cell") do
								xml.tag!("ss:Data", comment.attributes.values_at(*c), :"ss:Type"=>"String")
							end
						end
					end
				end
			end
			xml.tag! "ss:Row" do
				xml.tag! "ss:Cell" do
					xml.tag!("ss:Data", "Blog Posts", :"ss:Type"=>"String")
				end
			end
			if !current_user.blog.nil? && current_user.blog.blog_posts.any?
				xml.tag! "ss:Row" do
					BlogPost.column_names.each do |c|
						xml.tag!("ss:Cell") do
							xml.tag!("ss:Data", c, :"ss:Type"=>"String")
						end
					end
				end
				current_user.blog.blog_posts.each do |blog_post|
					xml.tag! "ss:Row" do
						BlogPost.column_names.each do |c|
							xml.tag!("ss:Cell") do
								xml.tag!("ss:Data", blog_post.attributes.values_at(*c), :"ss:Type"=>"String")
							end
						end
					end
				end
			end
		end
	end
end