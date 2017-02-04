# frozen_string_literal: true
class Hash # :nodoc:
  def stringify_keys
    result = self.class.new
    each_key do |key|
      result[key.to_s] = self[key]
    end
    result
  end
end
