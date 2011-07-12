require 'rubygems'
require 'sinatra'
require 'compass'
require 'erb'
require 'haml'
require 'gcal4ruby'
require 'require_all'
require 'bundler'

Bundler.require
require_all 'lib'

configure do
  set :haml, { :format => :html5, :escape_html => true }
  set :scss, { :style => :compact, :debug_info => false }
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))

  GOOGLE_LOGIN   = 'meetings@crowdint.com'
  GOOGLE_PASS    = 'cr0wd1nt'
  CALENDAR       = 'meetings%40crowdint.com'
end

get '/' do
  # http://code.google.com/intl/es-MX/apis/calendar/data/2.0/reference.html

  # Connect to Google Calendar
  service = GCal4Ruby::Service.new
  service.authenticate(GOOGLE_LOGIN, GOOGLE_PASS)

  # Get the calendar
  @calendar = GCal4Ruby::Calendar.find(service, { :id => CALENDAR }, :first)

  # Get all events
  #@events = @calendar.events

  # Get next week events
  @events = GCal4Ruby::Event.find(service, {}, {
      'calendar'        => @calendar.id,
      'singleevents'    => true,                      # Indicates whether recurring events should be expanded or represented as a single event.
      'start-min'       => Date.today.to_date,        # Start range
      'start-max'       => 1.week.from_now.to_date,   # End range
      'max-results'     => 25,                        # 25 by default
      'orderby'         => 'starttime',               # Specifies order of entries in a feed.
      'sortorder'       => 'ascending'                # Specifies direction of sorting.
  })

  haml :index
end