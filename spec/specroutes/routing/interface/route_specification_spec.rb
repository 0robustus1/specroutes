require 'rails_helper'

describe Specroutes::Routing::Interface::RouteSpecification do
  context 'with query constraint' do
    context 'and custom constraints' do
      let(:constraint) { Specroutes::Constraints::BaseConstraint.new }
      let(:route) { {'/simple?constraint=bool' => 'simple#index'} }
      let(:args) { route.merge(constraints: constraint) }
      let(:specification) { described_class.new('get', [args]) }

      before do
        specification.define_constraints
      end

      it 'should contain a grouped constraint' do
        expect(specification.match_options.last[:constraints]).
          to be_a(Specroutes::Constraints::GroupedConstraint)
      end

      context 'and the grouped constraint' do
        let(:group) { specification.match_options.last[:constraints] }

        it 'should contain two constraints' do
          expect(group.constraints.length).to eq(2)
        end

        it 'should contain the defined constraint' do
          expect(group.constraints).to include(constraint)
        end
      end


    end
  end
end
