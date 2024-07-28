import 'package:core/src/abstractions/service_bus.dart';

class ServiceBusImpl implements ServiceBus {
  final List<ServiceBusSubscription> _subscriptions = [];

  @override
  Future<void> publish<T>({required T data, required ServiceBusEvent event}) {
    _subscriptions.where((element) => element.event.eventId == event.eventId).forEach((element) {
      element.subscriber.onEventPublished(data, event);
    });
    return Future.value();
  }

  @override
  Future<void> unsubscribe({required ServiceBusSubscriber serviceBusSubscriber, required ServiceBusEvent event}) {
    _subscriptions.removeWhere((element) => element.subscriber == serviceBusSubscriber && element.event.eventId == event.eventId);
    return Future.value();
  }

  @override
  Future<void> subscribe({required ServiceBusSubscriber serviceBusSubscriber, required ServiceBusEvent event}) {
    _subscriptions.add(ServiceBusSubscription(subscriber: serviceBusSubscriber, event: event));
    return Future.value();
  }
}
