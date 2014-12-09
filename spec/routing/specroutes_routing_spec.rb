require 'rails_helper'

describe ProductsController do
  context 'without query string' do
    context 'and in resources-like route' do
      it 'should route a get to the controller' do
        expect(get: '/products/').
          to route_to(controller: 'products', action: 'index')
      end

      it 'should route a get with param to the controller' do
        expect(get: '/products/1').
          to route_to(controller: 'products', action: 'show', id: '1')
      end
    end
  end

  context 'with a query string' do
    context 'and in a resources-like route' do
      it 'should route a get with param to the controller' do
        expect(get: '/cars/1?make=something&model=other').
          to route_to(controller: 'products', action: 'show', id: '1')
      end
    end
  end
end
