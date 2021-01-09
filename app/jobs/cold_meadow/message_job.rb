class ColdMeadow::MessageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Process/Send Pending Messages
  end
end
