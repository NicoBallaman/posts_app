abstract class ServiceBus {
  Future<void> subscribe({required ServiceBusSubscriber serviceBusSubscriber, required ServiceBusEvent event});

  Future<void> unsubscribe({required ServiceBusSubscriber serviceBusSubscriber, required ServiceBusEvent event});

  Future<void> publish<T>({required T data, required ServiceBusEvent event});
}

abstract class ServiceBusSubscriber {
  Future<void> onEventPublished<T>(T data, ServiceBusEvent event);
}

class ServiceBusSubscription {
  final ServiceBusSubscriber subscriber;
  final ServiceBusEvent event;

  ServiceBusSubscription({required this.subscriber, required this.event});
}

class ServiceBusEvent {
  final String eventId;
  const ServiceBusEvent({required this.eventId});
}
