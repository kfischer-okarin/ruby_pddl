# frozen_string_literal: true

require_relative '../../../spec_helper'

module Tensai::Pddl
  module Action
    RSpec.describe Strips do
      describe '#name' do
        subject { Strips.new(name) }

        it_behaves_like 'a named object'
      end

      describe '#parameters' do
        subject { Strips.new('action', parameters: variables) }

        it_behaves_like 'a object containing variables', :parameters
      end

      describe '#precondition' do
        subject { Strips.new('action', parameters: [], precondition: precondition) }

        def self.atom
          Formula::Atom.new(Predicate.new('a'), {})
        end

        VALID_PRECONDITIONS = [
          atom,
          atom.and(atom)
        ].freeze

        VALID_PRECONDITIONS.each do |precondition|
          context "with #{precondition}" do
            let(:precondition) { precondition }

            it 'does not raise error' do
              expect(subject.precondition).to eq(precondition)
            end
          end
        end

        INVALID_PRECONDITIONS = [
          atom.not,
          atom.and(atom.not)
        ].freeze

        INVALID_PRECONDITIONS.each do |precondition|
          context "with #{precondition}" do
            let(:precondition) { precondition }

            it 'raises an error ArgumentError' do
              expect { subject.precondition }.to raise_error Dry::Types::ConstraintError
            end
          end
        end
      end
    end
  end
end
