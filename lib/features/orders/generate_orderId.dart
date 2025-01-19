import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart'; // Import for generating UUIDs

final db = Db('mongodb://yourMongoDBConnectionString'); // MongoDB connection
final ordersCollection = db.collection('orders');

Future<String> generateShortOrderId() async {
  // Create a UUID instance
  final uuid = Uuid();
  // Generate a unique part and truncate it to 8 characters for brevity
  String uniquePart = uuid.v4().replaceAll('-', '').substring(0, 8); 
  
  // Create user-friendly order ID
  return 'ORD-$uniquePart'; // Combine with a prefix
}

Future<void> createOrder(Map<String, dynamic> orderDetails) async {
  final String orderId = await generateShortOrderId(); // Generate the order ID

  // Insert the new order into the orders collection
  await ordersCollection.insertOne({
    'orderId': orderId,
    'userId': orderDetails['userId'],
    'items': orderDetails['items'],
    'status': 'Pending', // Example status
    'createdAt': DateTime.now(),
  });

  print('Order created with ID: $orderId');
}

Future<void> main() async {
  // Example order details
  final orderDetails = {
    'userId': 'user123',
    'items': [
      {'productId': 'prod001', 'quantity': 2},
      {'productId': 'prod002', 'quantity': 1},
    ],
  };

  // Create a new order
  await createOrder(orderDetails);

  // Close the database connection
  await db.close();
}
