module ApplicationHelper

  def include_analytics_tracking
    render :partial => "shared/analytics_tracking"
  end

end
