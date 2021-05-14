# frozen_string_literal: true

if defined?(AmazingPrint)
  # We could have run AmazingPrint.pry! to have output be formatted by ap but
  # doing it this way allows us to keep using pry's pager.
  Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output) }
end
