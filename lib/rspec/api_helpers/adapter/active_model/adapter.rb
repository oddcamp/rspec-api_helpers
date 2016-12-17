class Adapter
  class ActiveModel
    include RSpec::Matchers

    class << self
      def resource(options, response, _binding)
        hashed_response = HashWithIndifferentAccess.new(JSON.parse(response.body))

        return Resource.new(options, hashed_response, _binding)
      end

      def collection(options, response, _binding)
        hashed_response = HashWithIndifferentAccess.new(JSON.parse(response.body))

        return Collection.new(options, hashed_response, _binding)
      end
    end
  end
end
