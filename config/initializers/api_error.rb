Rails.configuration.to_prepare do
  class ApiUnauthError < StandardError
  end

  class ApiBadreqError < StandardError
  end

  class ApiNotfoundError < StandardError
  end
end
