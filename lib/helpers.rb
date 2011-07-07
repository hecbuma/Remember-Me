helpers do
  def time_diff_in_minutes( time_from, time_to=Time.now )
    diff_seconds = (time_to - time_from).round
    diff_minutes = diff_seconds / 60
    diff_minutes
  end
end
