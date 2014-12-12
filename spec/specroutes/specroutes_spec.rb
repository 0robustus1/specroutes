require 'rails_helper'

describe Specroutes do
  let(:rails_routes) { ActionDispatch::Routing::RouteSet.new }
  let(:error_klass) { Specroutes::Serializer::Errors::UnknownDatatypeError }

  context 'when providing an invalid datatype' do
    let(:spec_routes) do
      Specroutes.define(rails_routes) do
        specified_get '/erroneous?unknown=unknown' => 'unknown_controller#index'
      end
    end

    it 'serializing should fail' do
      expect { Specroutes.serialize(spec_routes) }.
        to raise_error(error_klass)
    end
  end

  context 'when providing a valid route-definition' do
    let(:spec_routes) do
      Specroutes.define(rails_routes) do
        specified_get '/valid?valid=xsd:boolean' => 'valid#index'
      end
    end

    it 'serializing should not fail' do
      expect { Specroutes.serialize(spec_routes) }.
        to_not raise_error
    end
  end
end
