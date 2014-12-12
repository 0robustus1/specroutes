require 'rails_helper'

describe Specroutes::Serializer do
  let(:rails_routes) { ActionDispatch::Routing::RouteSet.new }

  it 'should return xml as a default serializer' do
    expect(Specroutes::Serializer::DEFAULT).
      to eq(Specroutes::Serializer::XML)
  end

  context 'when serializing a doc-route' do
    let(:doc_title) { 'The simple route' }
    let(:doc_lang) { 'en' }
    let(:doc_body) { 'This is the body for the simple route.' }
    let(:spec_routes) do
      doc = {title: doc_title, lang: doc_lang, body: doc_body}
      Specroutes.define(rails_routes) do
        specified_get '/simple' => 'simple#index', doc: doc
      end
    end

    let(:serialization) { Specroutes.serialize(spec_routes) }
    let(:parser) { ::XML::Parser.string(serialization).parse }
    let(:doc_el) { parser.find_first('//doc') }

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
end
