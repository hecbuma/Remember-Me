helpers do
  def time_diff_in_minutes( time_from, time_to=Time.now )
    diff_seconds = (time_from - time_to).round
    diff_minutes = diff_seconds / 60

#    puts "minutes between #{time_from} and #{time_to} == #{diff_minutes}"
    diff_minutes
  end
end
