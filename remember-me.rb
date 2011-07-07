require 'compass'
require 'sinatra'
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
  GOOGLE_PASS    = ''
  CALENDAR       = ''
end

get '/' do
  # Step 1
  service = GCal4Ruby::Service.new
  service.authenticate(GOOGLE_LOGIN, GOOGLE_PASS)

  # Step 2
  @calendar = GCal4Ruby::Calendar.find(service, { :id => CALENDAR }, :first)

  haml :index
end
