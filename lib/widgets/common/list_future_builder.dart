/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListFutureBuilder<T, Y> extends StatelessWidget {
  final Function onBuild;
  final Future<List<Y>> future;
  final Function onError;
  final Function onWaiting;

  const ListFutureBuilder({
    Key? key,
    required this.onBuild,
    required this.future,
    this.onError,
    this.onWaiting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Y>> snapshot) {
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
