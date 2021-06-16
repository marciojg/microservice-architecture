require 'rails_helper'

RSpec.describe Order, type: :model do
  before do
    allow(Rails.cache).to receive(:read)
      .with(CartsConsumer::CACHE_NAME)
      .and_return([ { 'client_id' => '123' } ])
  end

  describe 'Validation' do
    let(:params) { { status: :open } }

    context 'cart_client_id' do
      it do
        expect validate_numericality_of(:cart_client_id)
                .only_integer
                .is_greater_than_or_equal_to(0)
      end

      context 'uniqueness' do
        before { create :order, params }

        let(:order) { build :order, params }

        it do
          order.save

          expect(order.errors['cart_client_id']).to include('has already been taken')
        end
      end

      context 'inclusion' do
        let(:order) { build :order, params.merge(cart_client_id: 555) }

        it do
          order.save

          expect(order.errors['cart_client_id']).to include('555 is not a valid')
        end
      end
    end
  end

  describe '#close' do
    let(:order) { create :order, status: :open }

    it do
      order.close

      expect(order.status).to eq('closed')
    end
  end

  describe 'Callbacks' do
    context 'after_create' do
      let(:orders) { DeliveryBoy.testing.messages_for('ORDERS_CHANNEL') }
      let(:total_items) { DeliveryBoy.testing.messages_for('TOTAL_ITEMS_CHANNEL') }

      let(:order) { build :order }

      before { order.save }

      it 'ORDERS_CHANNEL' do
        message = JSON.parse(orders[0].value)

        expect(orders[0].key).to eq 'CREATED'

        expect(message['order_id']).to eq order.id
        expect(message['cart_client_id']).to eq order.cart_client_id
      end

      it 'TOTAL_ITEMS_CHANNEL' do
        message = JSON.parse(total_items[0].value)

        expect(total_items[0].key).to be_nil

        expect(message['order_id']).to eq order.id
        expect(message['cart_client_id']).to eq order.cart_client_id
      end
    end

    context 'after_update' do
      let(:orders) { DeliveryBoy.testing.messages_for('ORDERS_CHANNEL') }
      let(:remove_items) { DeliveryBoy.testing.messages_for('CART_ITEMS_REMOVE_CHANNEL') }

      let(:order) { create :order }

      before { order.close }

      it 'ORDERS_CHANNEL' do
        message = JSON.parse(orders[1].value)

        expect(orders[1].key).to eq 'CLOSED'

        expect(message['order_id']).to eq order.id
        expect(message['cart_client_id']).to eq order.cart_client_id
      end

      it 'CART_ITEMS_REMOVE_CHANNEL' do
        message = JSON.parse(remove_items[0].value)

        expect(remove_items[0].key).to be_nil

        expect(message['order_id']).to eq order.id
        expect(message['cart_client_id']).to eq order.cart_client_id
      end
    end
  end
end
