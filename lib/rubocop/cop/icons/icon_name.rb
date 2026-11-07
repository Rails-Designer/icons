# frozen_string_literal: true

module RuboCop
  module Cop
    module Icons
      class IconName < Base
        def on_send(node)
          pattern = ::Icons::Cop.call_patterns.find do |candidate|
            ::Icons::Cop::Source.matches?(node, candidate)
          end
          return unless pattern

          ::Icons::Cop::Source.new(node, pattern).references.each do |reference|
            message, offense_node = ::Icons::Cop::Checker.new(reference).call
            add_offense(offense_node, message: message) if message
          end
        end
      end
    end
  end
end
