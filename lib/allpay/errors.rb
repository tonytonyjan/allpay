module Allpay
  # Generic Allpay exception class.
  class AllpayError < StandardError; end
  class MissingOption < AllpayError; end
  class InvalidMode < AllpayError; end
end
