/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemFutureBuilder<T, Y> extends StatelessWidget {
  final Function onBuild;
  final Future<Y> future;
  final Function onError;
  final Function onWaiting;

  const ItemFutureBuilder(
      {Key? key,
      required this.onBuild,
      required this.future,
      this.onError,
      this.onWaiting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<Y> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            if (onError != null) {
              return onError(snapshot.error);
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
          }
          return Consumer<T>(
            builder: (BuildContext context, T value, Widget child) {
              return onBuild(context, value, child);
            },
          );
        } else {
          return onWaiting == null
              ? Center(child: CircularProgressIndicator())
              : Consumer<T>(
                  builder: (BuildContext context, T value, Widget child) {
                    return onWaiting(value);
                  },
                );
        }
      },
      future: future,
    );
  }
}
 */
