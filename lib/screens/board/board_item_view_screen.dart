import 'package:Kuluma/tools/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../tools/utils.dart';
import '../../models/board_item.dart';
import '../../providers/board_provider.dart';
import '../../widgets/common/dwell_app_bar.dart';
import '../../widgets/common/dwell_title.dart';
import 'widgets/board_item_comments/board_item_comments.dart';
import 'widgets/board_textfield.dart';

class BoardItemViewScreen extends StatefulWidget {
  static const routeName = '/board_item_view_screen';
  BoardItemViewScreen();

  @override
  _BoardItemViewScreenState createState() => _BoardItemViewScreenState();
}

class _BoardItemViewScreenState extends State<BoardItemViewScreen> {
  ScrollController _controller = ScrollController();
  TextEditingController textController = TextEditingController();
  BoardItem? boardItem;
  double textfieldHeight = 160;
  @override
  void dispose() {
    _controller.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    boardItem = ModalRoute.of(context)?.settings.arguments as BoardItem;

    final BoardItem pBoardItem = Provider.of<BoardProvider>(context)
        .boardItems!
        .firstWhere((element) => element.id == boardItem?.id);
    final List<BoardItem> list = [pBoardItem, ...pBoardItem.children];

    final w = MediaQuery.of(context).size.width;
    final b = MediaQuery.of(context).viewInsets.bottom;
    double h = MediaQuery.of(context).size.height;

    h = h - b;
    if (b != 0)
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

    if (Provider.of<BoardProvider>(context, listen: false).selectedItem !=
        boardItem?.id)
      Provider.of<BoardProvider>(context, listen: false).selectedItem =
          boardItem?.id;

    return WillPopScope(
      onWillPop: () async {
        Provider.of<BoardProvider>(context, listen: false).selectedItem = null;
        return true;
      },
      child: GestureDetector(
        onTap: () {
          Log.info('dismiss k');
          Utils.dismissKeyboard(context);
        },
        child: Scaffold(
          appBar: DwellAppBar(
              title: DwellTitle(
            title: "Kommentit",
          )),
          body: Stack(
            children: [
              Container(
                color: Color(0xFFE2E2E2),
                padding: EdgeInsets.only(bottom: 80),
                width: w,
                child: Container(
                  padding: EdgeInsets.all(0.0),
                  height: h,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return BoardItemInCommentsWidget(boardItem: list[index]);
                    },
                    controller: _controller,
                    itemCount: list.length,
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: BoardTextField(textController),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
