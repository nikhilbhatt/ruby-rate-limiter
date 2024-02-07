# frozen_string_literal: true

module RateLimiter
  # Implementation of Fixed Window Counter Algorithm
  class FixedWindowCounter
    MAX_NO_OF_REQUESTS_PER_MINUTE = 60
    TIME_DIFFERENCE = 60

    @request_logs = []
    class << self
      def valid_request?
        remove_expired_requests

        allow_request = !counter_full?
        add_new_request if allow_request
        allow_request
      end

      def add_new_request
        @request_logs.push(Time.now)
      end

      def remove_expired_requests
        return if @request_logs.empty?

        @request_logs.delete(
          @request_logs.first
        ) while @request_logs.size.positive? && Time.now - @request_logs.first > TIME_DIFFERENCE
      end

      def counter_full?
        @request_logs.size > MAX_NO_OF_REQUESTS_PER_MINUTE
      end
    end
  end
end
