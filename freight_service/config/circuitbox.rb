Circuitbox.configure do |config|
  config.default_circuit_store = Circuitbox::MemoryStore.new
  config.default_notifier = Circuitbox::Notifier::Null.new
  config.default_logger = Rails.logger
end
