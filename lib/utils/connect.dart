import 'dart:convert';

import 'package:demacia_dashboard/nt_widgets/nt_topic.dart';
import 'package:demacia_dashboard/nt_widgets/widgets/boolean_widget.dart';
import 'package:demacia_dashboard/utils/client.dart';

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

  void d() async {
    NT4Topic? topic = client.getTopicFromName('/SmartDashboard/field/Robot');
    if (topic != null) {
      print(topic.name);
      print('topic not null');
    } else {
      print('topic is null');
    }
  }

  void data() {
    NT4Topic testPub =
        client.publishNewTopic('/SmartDashboard/Second', NT4TypeStr.typeStr);
    client.addSample(testPub, 'WORK??');

    NT4Topic tester =
        client.publishNewTopic('/SmartDashboard/Third', NT4TypeStr.typeInt);
    client.addSample(tester, 5);

    NT4Topic boolT =
        client.publishNewTopic('/SmartDashboard/Bool', NT4TypeStr.typeBool);
    client.addSample(boolT, true);

    NT4Topic jsonTest =
        client.publishNewTopic('/SmarthDasbboard/json', NT4TypeStr.typeStr);
    Map<String, dynamic> object = {
      'Sarah': 15,
      'Test': 29,
      'Ver': 111,
    };

    String json = jsonEncode(object);
    client.addSample(jsonTest, json);

    NT4Topic? outSideTopic = client.getTopicFromName('outSideTopic');

    if (outSideTopic != null) {
      print("topic isnt null");
    } else {
      print('nulllll!');
    }
  }

  void testSub(List<NtTopic> topics) async {
    NT4Subscription sub = client.subscribePeriodic('/SmartDashboard/Third');

    sub.listen((data) {
      topics.add(NtTopic(
          name: 'Th',
          directory: extractDirectory('/SmartDashboard/Third'),
          type: getType(data),
          id: generateId(),
          data: data,
          size: 5.0));
    });

    NT4Subscription t = client.subscribePeriodic('/SmartDashboard/Second');
    t.listen((data) {
      topics.add(NtTopic(
          name: 'Se',
          directory: extractDirectory('/SmartDashboard/Second'),
          type: getType(data),
          id: generateId(),
          data: data,
          size: 5));
    });

    NT4Subscription s = client.subscribePeriodic('/SmarthDasbboard/Second');
    NT4Topic? tpc = client.getTopicFromName(s.topic);
    String sTopic = s.topic;
    print('topic: $sTopic');

    NT4Subscription workSub = client.subscribePeriodic('/SmarthDasbboard/json');

    workSub.listen((data) {
      topics.add(NtTopic(
          name: 'Name!',
          directory: extractDirectory('/SmartDashboard/json'),
          type: getType(data),
          id: generateId(),
          data: data,
          size: 5.0));
    });

    // NT4Subscription bs = client.subscribePeriodic('/SmartDashboard/Bool');
    // bs.listen((data) {
    //   if (getType(data) == bool) {
    //     topics.add(BooleanWidget(title: 'Bool', topic: client.getTopicFromName(bs.topic)));
    //   }
    //   topics.add(NtTopic(
    //       name: 'Bool',
    //       directory: extractDirectory('/SmartDashboard/Bool'),
    //       type: getType(data),
    //       id: generateId(),
    //       data: data,
    //       size: 5.0));
    // });
  }

  Type getType(dynamic value) {
    if (value == null) {
      return Null;
    }
    print(value.runtimeType);
    return value.runtimeType;
  }

  void sendDatas(String name, String type, Object value) {
    if (!isConnected) {
      print('Cannot send data: Client not connected');
      return;
    }

    NT4Topic topic = client.publishNewTopic('/SmartDashboard/$name', type);
    client.addSample(topic, value);
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
