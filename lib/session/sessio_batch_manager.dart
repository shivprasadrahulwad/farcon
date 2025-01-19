// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';
// import 'package:farcon/constants/global_variables.dart';
// import 'package:farcon/constants/utils.dart';
// import 'package:farcon/models/userSession.dart';
// import 'package:farcon/providers/user_provider.dart';

// class SessionBatchManager {
//   static const int BATCH_SIZE = 5;
//   static const String SESSIONS_STORAGE_KEY = 'pending_sessions';
  
//   /// Adds a session to the pending sessions list
//  static Future<void> queueSession(UserSession session, String shopCode, BuildContext context) async {
//   try {
//     // Get SharedPreferences instance
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
//     // Retrieve existing pending sessions or create a new list
//     List<String> pendingSessions = sharedPreferences.getStringList(SESSIONS_STORAGE_KEY) ?? [];
    
//     // Prepare session data
//     final sessionJson = jsonEncode({
//       'shopCode': shopCode,
//       'userSession': {
//         'sessionId': DateTime.now().millisecondsSinceEpoch.toString(),
//         'screensVisited': session.screensVisited.map((visit) => {
//           'screen': visit.screen,
//           'timestamp': visit.timestamp.toIso8601String(),
//           'shopId': shopCode,
//         }).toList(),
//         'actions': session.actions.map((action) => {
//           'action': action.action,
//           'item': action.item,
//           'timestamp': action.timestamp.toIso8601String(),
//           'shopId': shopCode,
//         }).toList(),
//         'deviceInfo': {
//           'deviceType': session.deviceInfo.deviceType,
//           'os': session.deviceInfo.os,
//           'osVersion': session.deviceInfo.osVersion,
//         },
//         'networkInfo': {
//           'networkType': session.networkInfo.networkType,
//           'location': session.networkInfo.location,
//         },
//       }
//     });
    
//     // Add new session to the list
//     pendingSessions.add(sessionJson);
    
//     // Save the updated list of sessions
//     await sharedPreferences.setStringList(SESSIONS_STORAGE_KEY, pendingSessions);
    
//     print('🟢 Session queued successfully');
//     print('🔍 Total pending sessions: ${pendingSessions.length}');
//   } catch (e) {
//     print('❌ Error queueing session: $e');
//     CustomSnackBar.show(context, 'Failed to queue session: $e');
//   }
// }


//   /// Attempts to process the batch of pending sessions
//   static Future<void> _tryProcessBatch(BuildContext context) async {
//     try {
//        print('🟢 Detailed Batch Processing Start');
    
//     final prefs = await SharedPreferences.getInstance();
    
//     // Debug: Check all keys
//     print('🔍 All SharedPreferences keys: ${prefs.getKeys()}');
    
//     // Explicitly check the specific key
//     print('🔍 Checking for $SESSIONS_STORAGE_KEY');
    
//     List<String>? pendingSessions = prefs.getStringList(SESSIONS_STORAGE_KEY);
    
//     print('🔍 Detailed Pending Sessions Check:');
//     print('🔍 pendingSessions is null: ${pendingSessions == null}');
    
//     if (pendingSessions == null || pendingSessions.isEmpty) {
//       print('🟡 No pending sessions to process');
//       print('🔍 Actual pendingSessions value: $pendingSessions');
      
//       // Additional debug: check SharedPreferences directly
//       final allStoredData = prefs.getKeys().map((key) {
//         return '$key: ${prefs.get(key)}';
//       }).toList();
      
//       print('🔍 All stored data: $allStoredData');
      
//       return;
//     }
      
//       // Determine how many sessions to process in this batch
//       final batchToProcess = pendingSessions.take(BATCH_SIZE).toList();
//       print('🟢 Processing batch with ${batchToProcess.length} sessions');
      
//       // Prepare batch for sending
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
      
//       for (var sessionJson in batchToProcess) {
//         final sessionData = jsonDecode(sessionJson);
        
//         print('🟢 Sending session to server: ${sessionData['shopCode']}');
        
//         // Send each session individually to match the server endpoint
//         final response = await _sendSessionToServer(
//           sessionData['shopCode'], 
//           sessionData['userSession'], 
//           userProvider.user.token,
//           context
//         );
        
//         if (!response) {
//           print('❌ Failed to send session, stopping batch process');
//           // If sending fails, break the batch processing
//           break;
//         }
//       }
      
//       // Remove processed sessions from the list
//       pendingSessions.removeRange(0, batchToProcess.length);
//       await prefs.setStringList(SESSIONS_STORAGE_KEY, pendingSessions);
//       print('🟢 Processed sessions removed from pending list');
//     } catch (e) {
//       print('❌ Error processing session batch: $e');
//       print('❌ Error type: ${e.runtimeType}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error processing session batch: $e')),
//       );
//     }
//   }
  
//   /// Send individual session to the server
//   static Future<bool> _sendSessionToServer(
//   String shopCode, 
//   Map<String, dynamic> userSession, 
//   String authToken,
//   BuildContext context
// ) async {
//   try {
//     print('🔍 Sending session details:');
//     print('Shop Code: $shopCode');
//     print('Auth Token: $authToken');
//     print('User Session: $userSession');
    
//     final response = await http.post(
//       Uri.parse('$uri/api/admin/session-info'),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'x-auth-token': authToken,
//       },
//       body: jsonEncode({
//         'shopCode': shopCode,
//         'userSession': userSession,
//       }),
//     );
    
//     // Log full response details
//     print('🌐 Response Status Code: ${response.statusCode}');
//     print('🌐 Response Body: ${response.body}');
    
//     if (response.statusCode == 200) {
//       print('✅ Session data stored successfully');
//       return true;
//     } else {
//       print('❌ Failed to store session. Status Code: ${response.statusCode}');
//       print('❌ Response Body: ${response.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to store session data: ${response.body}')),
//       );
//       return false;
//     }
//   } catch (e) {
//     print('❌ Error sending session: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error sending session data: $e')),
//     );
//     return false;
//   }
// }

//   /// Periodically check and process pending sessions
//   static void startPeriodicBatchProcessing(BuildContext context) {
//     print('🟢 Starting periodic session batch processing every minute');
//     // Run batch processing every 5 minutes
//     Timer.periodic(Duration(minutes: 1), (_) {
//       _tryProcessBatch(context);
//     });
//   }
  
//   /// Manual trigger to process any pending sessions
//   static Future<void> processPendingSessions(BuildContext context) async {
//     print('🟢 Manually triggering pending session processing');
//     await _tryProcessBatch(context);
//   }
// }

// // Extension method to easily queue sessions
// extension SessionQueueing on UserSession {
//   Future<void> queueForSync(String shopCode, BuildContext context) async {
//     print('🟢 Queueing session for sync from extension');
//     await SessionBatchManager.queueSession(this, shopCode, context);
//   }
// }

// // Modify your existing session end method
// void endSession(BuildContext context) {
//   final sessionEnd = DateTime.now();
//   final activeTime = sessionEnd.difference(currentSession!.sessionStart).inSeconds;
//   print("🟢 Session Ended. Total Active Time: $activeTime seconds");

//   // Queue the session for batch processing instead of immediate sync
//   currentSession?.queueForSync(currentSession!.shopId, context);
//   currentSession = null;
// }

// // Initialize batch processing when your app starts
// void initializeSessionTracking(BuildContext context) {
//   print('🟢 Initializing session tracking');
//   // Start periodic batch processing
//   SessionBatchManager.startPeriodicBatchProcessing(context);
// }
