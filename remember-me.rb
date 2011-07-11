require 'rubygems'
require 'sinatra'
require 'compass'
require 'erb'
require 'haml'
require 'gcal4ruby'
require 'require_all'

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
  # Connect to Google Calendar
  service = GCal4Ruby::Service.new
  service.authenticate(GOOGLE_LOGIN, GOOGLE_PASS)

  # Get the calendar
  @calendar = GCal4Ruby::Calendar.find(service, { :id => CALENDAR }, :first)

  # Get all events
  #@events = @calendar.events

  # Get only the future events
  @events = GCal4Ruby::Event.find(service, {}, {
      :futureevents   => true,
      :calendar       => @calendar.id,
      'max-results'   => 10
  }).sort{ |a,b| a.start_time <=> b.start_time }

  haml :index
end