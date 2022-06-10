// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:t_note/comment.dart';

// class CommentTile extends StatelessWidget {
//   final List? comment;
//   final int? index;
//   final widgetKey = GlobalKey();

//   CommentTile({Key? key, this.comment, this.index}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           key: widgetKey,
//           onLongPress: () {
//             showMenu(
//                 context: context,
//                 position: _getRelativeRect(widgetKey),
//                 items: <PopupMenuEntry>[
//                   PopupMenuItem(
//                     onTap: () {
//                       showCupertinoDialog(
//                           context: context,
//                           builder: (context) {
//                             return CupertinoAlertDialog(
//                               title: const Text(
//                                 'Edit Comment',
//                                 textAlign: TextAlign.center,
//                               ),
//                               content: CupertinoTextField(
//                                 controller: _editComment,
//                               ),
//                               actions: [
//                                 CupertinoDialogAction(
//                                   isDefaultAction: true,
//                                   onPressed: () => {
//                                     editComment(
//                                         _commentList[index]['comment_id'],
//                                         _editComment.text.toString()),
//                                     Navigator.pop(context),
//                                   },
//                                   child: const Text('Edit'),
//                                 ),
//                                 CupertinoDialogAction(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text('Cancel'),
//                                 ),
//                               ],
//                             );
//                           });
//                     },
//                     value: 1,
//                     child: const Text('Edit'),
//                   ),
//                   PopupMenuItem(
//                     onTap: () {
//                       print("delete");
//                     },
//                     // value: 2,
//                     child: const Text('Delete'),
//                   )
//                 ]);
//           },
//           // leading: Text('${index + 1}'),
//           title: Text(
//             _commentList[index]['user_firstname'] +
//                 " " +
//                 _commentList[index]['user_lastname'],
//             style: const TextStyle(fontSize: 12),
//           ),
//           subtitle: Text(_commentList[index]['comment'],
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 16, color: Colors.black)),
//           trailing: Text(
//             DateFormat('dd MMM HH:mm')
//                 .format(DateTime.parse(_commentList[index]['comment_date'])),
//             style: const TextStyle(fontSize: 12),
//           ),
//         ),
//         const Divider(
//           height: 0,
//         )
//       ],
//     );
//   }

//   RelativeRect _getRelativeRect(GlobalKey key) {
//     return RelativeRect.fromSize(
//         _getWidgetGlobalRect(key), const Size(200, 200));
//   }

//   Rect _getWidgetGlobalRect(GlobalKey key) {
//     final RenderBox renderBox =
//         key.currentContext!.findRenderObject() as RenderBox;
//     var offset = renderBox.localToGlobal(Offset.zero);
//     debugPrint('Widget position: ${offset.dx} ${offset.dy}');
//     return Rect.fromLTWH(offset.dx / 3.1, offset.dy * 1.05,
//         renderBox.size.width, renderBox.size.height);
//   }
// }
