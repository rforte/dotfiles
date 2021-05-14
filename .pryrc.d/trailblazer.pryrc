# frozen_string_literal: true

class Trailblazer::Operation::Result
  def to_hash
    instance_variable_get(:@data).to_hash if instance_variable_get(:@data).respond_to?(:to_hash)
  rescue StandardError
    warn 'WARNING: Not a TRB Result object?'
    nil
  end

  def trb_vars
    result = self
    result.to_hash.keys
  rescue StandardError
    warn 'WARNING: Not a TRB Result object?'
    nil
  end
end
