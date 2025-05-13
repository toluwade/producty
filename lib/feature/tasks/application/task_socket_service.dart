// import 'dart:developer';
//
// import 'package:flutter/foundation.dart';
// import 'package:producty/core/api/endpoints.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// import '../data/model/task.dart';
//
// class TaskSocketService {
//   late IO.Socket socket;
//
//   void connect(String token) {
//     socket = IO.io(Endpoints.base, <String, dynamic>{
//       'transports': ['websocket'],
//       'extraHeaders': {
//         'Authorization': 'Bearer $token',
//       },
//     });
//
//     socket.onConnect((_) {
//       if (kDebugMode) log('Connected to task socket');
//     });
//
//     socket.on('task:created', (data) {
//       final task = Task.fromJson(data);
//       // Update your state with the new task
//     });
//
//     socket.on('task:updated', (data) {
//       final task = Task.fromJson(data);
//       // Update your state with the updated task
//     });
//
//     socket.on('task:deleted', (taskId) {
//       // Remove the task from state using taskId
//     });
//
//     socket.on('task:restored', (data) {
//       final task = Task.fromJson(data);
//       // Add the restored task back to your state
//     });
//
//     socket.onDisconnect((_) {
//       if (kDebugMode) log('Disconnected from task socket');
//     });
//   }
//
//   void disconnect() {
//     socket.disconnect();
//   }
// }
