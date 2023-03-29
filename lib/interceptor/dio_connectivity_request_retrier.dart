import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioConnectivityRequestRetrier {
  final Dio dio;
  final Connectivity connectivity;

  DioConnectivityRequestRetrier({
    @required this.dio,
    @required this.connectivity,
  });

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    // TODO: Implement
final responseCompleter = Completer<Response>();
     StreamSubscription streamSubscription;
     streamSubscription = connectivity.onConnectivityChanged.listen(
    (connectivityResult) async {
      // We're connected either to WiFi or mobile data
      if (connectivityResult != ConnectivityResult.none) {
        // Ensure that only one retry happens per connectivity change by cancelling the listener
        streamSubscription.cancel();
        // Copy & paste the failed request's data into the new request
       responseCompleter.complete(  dio.request(
          requestOptions.path,
          cancelToken: requestOptions.cancelToken,
          data: requestOptions.data,
          onReceiveProgress: requestOptions.onReceiveProgress,
          onSendProgress: requestOptions.onSendProgress,
          queryParameters: requestOptions.queryParameters,
          //options: requestOptions,
        ),
        );
      }
    },
  );
 return responseCompleter.future;
  }
}
