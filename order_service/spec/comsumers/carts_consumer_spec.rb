require 'rails_helper'

RSpec.describe CartsConsumer do
  let(:consumer) { CartsConsumer.new }
  let(:received_message) { JSON.parse(message.value) }

  let(:key) { 'CREATED' }
  let(:value) { { id: 1, client_id: 123 }.to_json }
  let(:message) do
    double('message',
           key: key,
           value: value,
           topic: 'CARTS_CHANNEL',
           partition: 1, offset: 12)
  end

  subject { Rails.cache.read(CartsConsumer::CACHE_NAME) }

  before do
    allow(Rails).to receive(:cache)
      .and_return(ActiveSupport::Cache.lookup_store(:memory_store))

    consumer.process(message)
  end

  after { Rails.cache.clear }

  context 'when CREATED' do
    it { expect(subject).to eq([received_message]) }
  end

  context 'when DESTROYED' do
    before { consumer.process(double('message', key: 'DESTROYED', value: value)) }

    it { expect(subject).to be_empty }
  end

  context 'when type not found' do
    let(:key) { 'XYZ' }

    it { expect(subject).to be_nil }
  end

  context 'when rescue JSON::ParseError' do
    let(:value) { 'XYZ' }

    it { expect(subject).to be_nil }
  end
end
