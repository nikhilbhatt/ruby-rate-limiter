# frozen_string_literal: true

module RateLimiter
  # Token Bucket algorithm
  class TokenBucket
    BUCKET_MAX_SIZE_PER_REQUEST = 10

    @tokens = {}

    class << self
      def init_bucket(ip)
        return unless @tokens[ip].nil?

        @tokens[ip] = {
          count: BUCKET_MAX_SIZE_PER_REQUEST,
          last_refill_time: Time.now
        }
      end

      def valid_request?(ip)
        init_bucket(ip)
        tokens = refill_bucket(ip, @tokens)
        tokens = remove_token(tokens, ip) if tokens[ip.to_s][:count] >= 0

        tokens[ip.to_s][:count] >= 0
      end

      def remove_token(tokens, ip)
        tokens[ip.to_s][:count] -= 1
        tokens
      end

      def refill_bucket(ip, tokens)
        return if tokens[ip.to_s][:count] > 10

        current_time = Time.now
        tokens[ip.to_s][:count] = calulate_tokens_to_add(tokens, ip, current_time)
        tokens[ip.to_s][:last_refill_time] = current_time
        tokens
      end

      def calulate_tokens_to_add(tokens, ip, current_time)
        tokens_to_add = (current_time - tokens[ip.to_s][:last_refill_time]).to_i
        [tokens[ip.to_s][:count] + tokens_to_add, BUCKET_MAX_SIZE_PER_REQUEST].min
      end
    end
  end
end
