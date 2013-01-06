class EventsController < AuthenticatedController
	skip_before_filter :signed_in_user, only: [:index, :show]
end