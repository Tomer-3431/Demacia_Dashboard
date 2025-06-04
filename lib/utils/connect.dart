import 'package:demacia_dashboard/nt_widgets/nt_topic.dart';
import 'package:nt4/nt4.dart';

class Connect {
  late NT4Client client;

  int count = 0;
  Set<String> seenTopics = {};
  NT4Subscription? topicsSubscription;
  bool isConnected = false;

  Connect() {
    client = NT4Client(
      serverBaseAddress: 'localhost',
      onConnect: () {
        print('NT4 Client Connected');
        isConnected = true;
      },
      onDisconnect: () {
        print('NT4 Client Disconnected');
        isConnected = false;
      },
    );
  }

  void sendData() {
    if (!isConnected) {
      print('Cannot send data: Client not connected');
      return;
    }

    try {
      NT4Topic testPub =
          client.publishNewTopic('/SmartDashboard/Second', NT4TypeStr.typeStr);
      client.addSample(testPub, 'WORK??');
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  void data() {
    NT4Topic testPub =
        client.publishNewTopic('/SmartDashboard/Second', NT4TypeStr.typeStr);
    client.addSample(testPub, 'WORK??');
  }

  void sendDatas(String name, Type data, Object value) {
    if (!isConnected) {
      print('Cannot send data: Client not connected');
      return;
    }

    try {
      late NT4Topic testPub;

      switch (data) {
        case const (int):
          testPub = client.publishNewTopic(
              '/SmartDashboard/$name', NT4TypeStr.typeInt);

        case const (String):
          testPub = client.publishNewTopic(
              '/SmartDashboard/$name', NT4TypeStr.typeStr);

        case const (double):
          testPub = client.publishNewTopic(
              '/SmartDashboard/$name', NT4TypeStr.typeFloat64);

        case const (bool):
          testPub = client.publishNewTopic(
              '/SmartDashboard/$name', NT4TypeStr.typeBool);

        default:
          testPub = client.publishNewTopic(
              '/SmartDashboard/$name', NT4TypeStr.typeStr);
      }

      client.addSample(testPub, value);
    } catch (e) {
      print('Error sending data for $name: $e');
    }
  }

  void testSub(List<NtTopic> topics) async {
    NT4Subscription sub = client.subscribePeriodic('/SmartDashboard/name');
    sub.listen((data) {
      topics.add(NtTopic(
          name: 'name',
          directory: extractDirectory('/SmartDashboard/name'),
          type: getType(data as String),
          id: generateId(),
          data: data,
          size: 5.0));
    });
  }

  void getData(String data, Function(String) callback) async {
    if (!isConnected) {
      print('Cannot get data: Client not connected');
      return;
    }

    try {
      NT4Subscription subscriber =
          client.subscribePeriodic('/SmartDashboard/$data');
      subscriber.listen((data) {
        callback(data as String);
      });
    } catch (e) {
      print('Error subscribing to $data: $e');
    }
  }

  void fetchTopics(
      List<NtTopic> topics, Function(List<NtTopic>) onUpdate) async {
    print('Starting fetchTopics...');

    try {
      topicsSubscription = null;
    } catch (e) {
      print('Error cancelling previous subscription: $e');
    }

    seenTopics.clear();

    int connectionWaitCount = 0;
    while (!isConnected && connectionWaitCount < 50) {
      await Future.delayed(Duration(milliseconds: 100));
      connectionWaitCount++;
    }

    if (!isConnected) {
      print('Cannot fetch topics: Client not connected after waiting');
      return;
    }

    print('Client connected, starting topic subscription...');

    try {
      topicsSubscription = client.subscribe("/SmartDashboard",
          NT4SubscriptionOptions(prefix: true, topicsOnly: true));

      topicsSubscription!.listen((data) {
        print('Received subscription data: $data');

        try {
          if (data is Map<String, dynamic>) {
            final fullName = data['name'] as String?;
            final typeStr = data['type'] as String?;

            print('Topic found: $fullName, Type: $typeStr');

            if (fullName == null || seenTopics.contains(fullName)) {
              return;
            }
            seenTopics.add(fullName);

            final directory = extractDirectory(fullName);
            Type topicType;

            try {
              topicType = getType(typeStr ?? 'string');
            } catch (e) {
              print(
                  'Unknown type for $fullName: $typeStr, defaulting to String');
              topicType = String;
            }

            print('Subscribing to data for: $fullName');
            subscribeToSingleTopic(fullName, (actualData) {
              print('Got data for $fullName: $actualData');

              final topic = NtTopic(
                name: extractTopicName(fullName),
                directory: directory,
                type: topicType,
                id: generateId(),
                data: actualData,
                size: 96.0,
              );

              // Check if topic already exists before adding
              bool exists = topics.any((t) =>
                  t.name == topic.name && t.directory == topic.directory);
              if (!exists) {
                topics.add(topic);
                print(
                    'Added topic: ${topic.name}, Total topics: ${topics.length}');
                onUpdate(List.from(
                    topics)); // Create a copy to avoid reference issues
              }
            });
          } else {
            print('Unexpected data format: $data');
          }
        } catch (e) {
          print('Error processing topic data: $e');
        }
      });
    } catch (e) {
      print('Error creating subscription: $e');
    }
  }

  void subscribeToSingleTopic(
      String topicPath, Function(dynamic) onDataReceived) {
    try {
      NT4Subscription dataSubscription = client.subscribePeriodic(topicPath);

      dataSubscription.listen((data) {
        print('Received data from $topicPath: $data');
        onDataReceived(data);
      });
    } catch (e) {
      print('Failed to subscribe to $topicPath: $e');
    }
  }

  int generateId() {
    return ++count;
  }

  String extractDirectory(String path) {
    int lastSlash = path.lastIndexOf('/');
    if (lastSlash > 0) {
      return path.substring(0, lastSlash);
    } else {
      return 'root';
    }
  }

  String extractTopicName(String fullPath) {
    int lastSlash = fullPath.lastIndexOf('/');
    if (lastSlash >= 0 && lastSlash < fullPath.length - 1) {
      return fullPath.substring(lastSlash + 1);
    }
    return fullPath;
  }

  Type getType(String type) {
    switch (type.toLowerCase()) {
      case 'int':
      case 'integer':
        return int;

      case 'double':
      case 'float':
      case 'float64':
        return double;

      case 'bool':
      case 'boolean':
        return bool;

      case 'string':
      case 'str':
        return String;

      default:
        print('Unknown type: $type, defaulting to String');
        return String;
    }
  }

  void testConnection() {
    print('Testing connection...');

    if (!isConnected) {
      print('Client not connected for test');
      return;
    }

    try {
      NT4Subscription subs = client.subscribePeriodic("/SmartDashboard/name");

      subs.listen((data) {
        print("Test subscription received: $data");
      });
    } catch (e) {
      print('Error in test connection: $e');
    }
  }
}
