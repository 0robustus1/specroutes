require 'rails_helper'

describe Specroutes::Serializer do
  let(:rails_routes) { ActionDispatch::Routing::RouteSet.new }
  let(:serialization) { Specroutes.serialize(spec_routes) }
  let(:parser) { ::XML::Parser.string(serialization).parse }

  it 'should return xml as a default serializer' do
    expect(Specroutes::Serializer::DEFAULT).
      to eq(Specroutes::Serializer::XML)
  end

  context 'when serializing a doc-route' do
    before do
      parser.root.namespaces.default_prefix = 'wadl'
    end

    let(:doc_title) { 'The simple route' }
    let(:doc_lang) { 'en' }
    let(:doc_body) { 'This is the body for the simple route.' }
    let(:spec_routes) do
      doc = {title: doc_title, lang: doc_lang, body: doc_body}
      Specroutes.define(rails_routes) do
        specified_get '/simple' => 'simple#index', doc: doc
      end
    end

    let(:doc_el) { parser.find_first('//wadl:doc') }

    it 'should contain the title in the result' do
      expect(doc_el.attributes['title']).to eq(doc_title)
    end

    it 'should contain the language in the result' do
      expect(doc_el.attributes['lang']).to eq(doc_lang)
    end

    it 'should contain the title in the result' do
      expect(doc_el.child.to_s).to eq(doc_body)
    end
  end

  context 'when serializing with a positional and a query-param arg' do
    before do
      parser.root.namespaces.default_prefix = 'wadl'
    end

    let(:query_key) { 'key' }
    let(:query_value) { 'string' }
    let(:query_positional) { 'name' }
    let(:spec_routes) do
      route = "/simple?#{query_positional};#{query_key}=#{query_value}"
      Specroutes.define(rails_routes) do
        specified_get route => 'simple#index'
      end
    end

    context 'wrt. the positional query-arg' do
      let(:query_el) { parser.find_first("//wadl-ext:param[@name='#{query_positional}']") }

      it 'should contain the arg' do
        expect(query_el).to_not be_nil
      end

      it 'should have "positional" set as style of the param' do
        expect(query_el.attributes['style']).to eq('positional')
      end

      it 'should have the "position" attribute set correctly' do
        expect(query_el.attributes['position']).to eq('0')
      end
    end

    context 'wrt. the query-param arg' do
      let(:query_el) { parser.find_first("//wadl:param[@name='#{query_key}']") }

      it 'should contain the arg' do
        expect(query_el).to_not be_nil
      end

      it 'should have the correct type set' do
        expect(query_el.attributes['type']).to eq("xsd:#{query_value}")
      end

      it 'should have "query" set as style of the param' do
        expect(query_el.attributes['style']).to eq('query')
      end
    end
  end
end
