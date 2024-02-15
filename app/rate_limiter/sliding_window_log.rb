# frozen_string_literal: true

module RateLimiter
  # Implementation of Sliding Window Log Algorithm
  class SlidingWindowLog
    MAX_NO_OF_REQUESTS_PER_MINUTE = 10
    EXPIRY_SECONDS = 60

    @request_logs = {}

    class << self
      def valid_request?(ip)
        can_serve_new_requests = can_serve_new_requests?(ip)
        insert_current_request(ip) if can_serve_new_requests
        can_serve_new_requests
      end

      def can_serve_new_requests?(ip)
        remove_outdated_logs(ip)

        @request_logs[ip].size < MAX_NO_OF_REQUESTS_PER_MINUTE
      end

      def insert_current_request(ip)
        @request_logs[ip] << Time.now
      end

      def remove_outdated_logs(ip)
        logs = @request_logs[ip] || []

        logs.each do |log|
          logs.delete(log) if Time.now - log > EXPIRY_SECONDS
        end

        @request_logs[ip] = logs
      end
    end
  end
end
