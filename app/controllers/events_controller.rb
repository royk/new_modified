class EventsController < AuthenticatedController
	skip_before_filter :signed_in_user, only: [:index, :show]

	def create
		@event = Event.new
		@event.update_attributes(params[:event])
		register_competitions
		if @event.save
			flash[:success] = "Event created"
		else
			flash[:error] = "Failed creating event"
		end
		redirect_to request.referer 
	end

	def update
		@event = Event.find(params[:id])
		unless @event.nil?
			@event.update_attributes(params[:event])
			register_attendant if params[:attendant]
			register_competitions
			@event.save
		end
		redirect_to request.referer
	end

	private 
		def register_attendant
			user = User.find(params[:attendant])
			unless user.nil?
				attendant = @event.attendants.find_by_user_id(user.id)
				if attendant.nil?
					attendant = @event.attendants.build(user: user, event: @event)
					attendant.save
				else
					Attendant.destroy(attendant.id)
				end
			end
		end

		def register_competitions
			unless @event.nil?
				i = 0
				until params[("Competition_#{i.to_s}").to_sym].nil?
					name = params[("Competition_#{i.to_s}").to_sym]
					competition = @event.competitions.find_by_index(i)
					if name.empty?
						unless competition.nil?
							# dissociate competitions that exist for the event, but weren't sent in this request
							competition.event_id = -1
							competition.save
						end
					else
						if competition.nil?
							competition = @event.competitions.build(name: name, event: @event, index: i)
							competition.save
						elsif competition.name!=name
							competition.name = name
							competition.save
						end
					end
					i += 1
				end
			end
		end

end