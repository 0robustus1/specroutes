require 'rails_helper'

describe Specroutes::Constraints::GroupedConstraint do
  let(:true_constraint) { double('constraint') }
  let(:false_constraint) { double('constraint') }
  let(:request) { double('request') }
    let(:grouped_constraint) { described_class.new(*args) }

  before do
    allow(true_constraint).to receive(:matches?).and_return(true)
    allow(false_constraint).to receive(:matches?).and_return(false)
  end

  context 'with inner true constraints' do
    let(:args) { [true_constraint] }

    it 'should return true on #matches?' do
      expect(grouped_constraint.matches?(request)).to be(true)
    end
  end

  context 'with mixed (true, false) constraints' do
    let(:args) { [true_constraint, false_constraint, true_constraint] }

    it 'should return false on #matches?' do
      expect(grouped_constraint.matches?(request)).to be(false)
    end
  end

  context 'with all false constraints' do
    let(:args) { [false_constraint, false_constraint] }

    it 'should return false on #matches?' do
      expect(grouped_constraint.matches?(request)).to be(false)
    end
  end
end
