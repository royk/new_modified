class AuthenticatedController < InheritedResources::Base
	before_filter :signed_in_user
end