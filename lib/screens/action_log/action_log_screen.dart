import 'package:Kuluma/models/board_item.dart';
// import 'package:Kuluma/providers/board_provider.dart';
// import 'package:Kuluma/providers/notification_provider.dart';
import 'package:Kuluma/providers/snackbar_provider.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/screens/screen_root.dart';
// import 'package:Kuluma/tools/logging.dart';
import 'package:Kuluma/tools/utils.dart';
import 'package:Kuluma/widgets/common/dwell_checkbox.dart';
import 'package:Kuluma/widgets/common/dwell_dialog.dart';
import 'package:Kuluma/widgets/common/dwell_layout_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

class ActionLogScreen extends StatefulWidget {
  static const routeName = '/action_log';

  @override
  State<ActionLogScreen> createState() => _ActionLogScreenState();
}

class _ActionLogScreenState extends State<ActionLogScreen> {
  List<String> _selectedMessages = [];
  late Future _fetchMessages;

  @override
  void initState() {
    super.initState();
    updateMessages();
  }

  void removeItems() {
    List<Future> toBeRemoved = _selectedMessages
        .map((e) =>
            context.read<User>().apiDelete(endpoint: 'account/messages/$e'))
        .toList();

    Future.wait(toBeRemoved).then((_) {
      updateState();
      context
          .read<SnackBarProvider>()
          .activateSnackBar(errorMessage: "Valitut tiedot poistettu");
    }).catchError((e) {
      updateState();
      context
          .read<SnackBarProvider>()
          .activateSnackBar(errorMessage: "Poisto epäonnistui");
    });
  }

  void updateState() {
    setState(() {
      updateMessages();
      _selectedMessages = [];
    });
  }

  void updateMessages() {
    _fetchMessages = context.read<User>().apiGet(endpoint: 'account/messages');
  }

  @override
  Widget build(BuildContext context) {
    DwellDialog confirm = DwellDialog(
      title: "Poista valitut",
      content: "Toimintalokin kautta poistetut tiedot poistetaan lopullisesti",
      onAccept: removeItems,
      acceptText: "Poista",
      cancelText: "Peruuta",
    );

    return GestureDetector(
      onTap: () {
        Utils.dismissKeyboard(context);
      },
      child: ScreenRoot(
        title: 'Toimintaloki',
        body: DwellLayoutBuilder(
          child: _ActionLogBody(
            selectedMessages: _selectedMessages,
            fetchMessages: _fetchMessages,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _selectedMessages.length > 0
              ? confirm.show(context: context)
              : context.read<SnackBarProvider>().activateSnackBar(
                  errorMessage: "Valitse poistettavat tiedot"),
          backgroundColor: DwellColors.primaryOrange,
          child: Icon(
            Icons.delete_forever,
            color: DwellColors.textWhite,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class _ActionLogBody extends StatefulWidget {
  const _ActionLogBody(
      {Key? key, required this.selectedMessages, required this.fetchMessages})
      : super(key: key);

  final List<String> selectedMessages;
  final Future fetchMessages;

  @override
  __ActionLogBodyState createState() => __ActionLogBodyState();
}

class __ActionLogBodyState extends State<_ActionLogBody> {
  late List<BoardItem> _messages;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var data = snapshot.data as Map<String, dynamic>;

          if (data['messages'] == null) {
            return ActionLogExceptionText(text: 'Tapahtui virhe');
          }

          List rawMessages = data['messages'];

          if (rawMessages.length == 0) {
            return ActionLogExceptionText(text: 'Ei näytettäviä tietoja');
          }

          _messages = rawMessages.map((a) => BoardItem.fromJson(a)).toList();

          _messages.sort((BoardItem a, BoardItem b) {
            return b.created.compareTo(a.created);
          });

          return ListView.builder(
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return _ActionLogItem(
                boardItem: _messages[index],
                selectedItems: widget.selectedMessages,
              );
            },
            itemCount: _messages.length,
            cacheExtent: double.infinity,
          );
        }

        return Container(
          child: SpinKitWanderingCubes(
            color: DwellColors.primaryOrange,
          ),
        );
      },
      future: widget.fetchMessages,
    );
  }
}

class ActionLogExceptionText extends StatelessWidget {
  const ActionLogExceptionText({Key? key, required this.text})
      : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                text,
                style: TextStyle(color: DwellColors.textWhite),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionLogItem extends StatefulWidget {
  const _ActionLogItem({
    Key? key,
    required this.boardItem,
    required this.selectedItems,
  }) : super(key: key);

  final BoardItem boardItem;
  final List<String> selectedItems;

  @override
  __ActionLogItemState createState() => __ActionLogItemState();
}

class __ActionLogItemState extends State<_ActionLogItem> {
  bool _selection = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: DwellColors.backgroundLight),
        ),
      ),
      height: 130,
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      DateFormat.yMMMd().format(widget.boardItem.created),
                      style: TextStyle(
                        color: DwellColors.primaryOrange,
                        fontSize: 16,
                        fontFamily: 'Sofia Pro',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      widget.boardItem.body,
                      style: TextStyle(
                        color: DwellColors.textWhite,
                        fontSize: 18,
                        fontFamily: 'Sofia Pro',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: DwellCheckBox(
              onTap: () {
                setState(() {
                  _selection = !_selection;
                  widget.selectedItems.contains(widget.boardItem.id)
                      ? widget.selectedItems.remove(widget.boardItem.id)
                      : widget.selectedItems.add(widget.boardItem.id);
                });
              },
              value: _selection,
            ),
          ),
        ],
      ),
    );
  }
}
