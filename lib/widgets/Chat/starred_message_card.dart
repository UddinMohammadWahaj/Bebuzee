import 'dart:io';
import 'dart:ui' as ui;

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'message_card.dart';

class StarredMessageCard extends StatefulWidget {
  final ChatMessagesModel message;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String image;
  final int index;
  final AutoScrollController controller;

  StarredMessageCard({
    required this.onTap,
    required this.onLongPress,
    required this.message,
    required this.image,
    required this.index,
    required this.controller,
  });

  @override
  _StarredMessageCardState createState() => _StarredMessageCardState();
}

class _StarredMessageCardState extends State<StarredMessageCard> {
  @override
  void initState() {
    // String query = "h";
    // String findAlice= widget.message.message.substring(widget.message.message.indexOf(query), query.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        color: widget.message.isSelected!
            ? darkColor.withOpacity(0.2)
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                                (widget.message.you == 1
                                        ? CurrentUser().currentUser.image
                                        : widget.message.userImage) ??
                                    ""),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.message.you == 1
                              ? AppLocalizations.of(
                                  "You",
                                )
                              : widget.message.username ?? "",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.black,
                          size: 15,
                        ),
                        Text(
                          widget.message.you == 0
                              ? AppLocalizations.of(
                                  "You",
                                )
                              : widget.message.username!,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          widget.message.dateData!,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                  color: Colors.grey,
                                  offset: new Offset(1.0, 1.0),
                                  blurRadius: 1.0)
                            ],
                            color: widget.message.you == 1
                                ? messageBubbleColor
                                : widget.message.you == 2
                                    ? darkColor.withOpacity(0.6)
                                    : Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        constraints: BoxConstraints(
                          minWidth: 80.0,
                          maxWidth: 280.0,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: widget.message.you == 2
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.end,
                          children: <Widget>[
                            widget.message.you == 0
                                ? Container(
                                    constraints: BoxConstraints(
                                      minWidth: 80.0,
                                    ),
                                    child: widget.message.messageType == "image"
                                        ? ClipRRect(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: 300,
                                                  width: 300,
                                                  child: widget.message
                                                              .receiverDownload ==
                                                          0
                                                      ? Image.file(
                                                          File(widget.message
                                                              .receiverDevicePath!),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : ImageFiltered(
                                                          imageFilter: ui
                                                                  .ImageFilter
                                                              .blur(
                                                                  sigmaY: 5,
                                                                  sigmaX: 5),
                                                          child: Container(
                                                            child:
                                                                Image.network(
                                                              widget.message
                                                                  .imageData
                                                                  .toString()
                                                                  .replaceAll(
                                                                      "/resized",
                                                                      ""),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                widget.message.receiverDownload ==
                                                            1 &&
                                                        widget.message
                                                                .isDownloading ==
                                                            false
                                                    ? Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Container(
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  color: Colors
                                                                      .black87,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          10),
                                                                  child: Icon(
                                                                    Icons
                                                                        .download_rounded,
                                                                    size: 30,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ))))
                                                    : Container(),
                                                widget.message.isDownloading!
                                                    ? Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 3,
                                                              valueColor:
                                                                  new AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .white),
                                                            )))
                                                    : Container()
                                              ],
                                            ),
                                          )
                                        : widget.message.messageType == "video"
                                            ? Container(
                                                height: 300,
                                                width: 300,
                                                child: ClipRRect(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 300,
                                                        width: 300,
                                                        child: widget.message
                                                                    .receiverDownload ==
                                                                0
                                                            ? Image.file(
                                                                File(widget
                                                                    .message
                                                                    .receiverThumbnail!),
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Container(
                                                                child:
                                                                    ImageFiltered(
                                                                imageFilter: ui
                                                                        .ImageFilter
                                                                    .blur(
                                                                        sigmaY:
                                                                            5,
                                                                        sigmaX:
                                                                            5), //SigmaX and Y are just for X and Y directions
                                                                child: Image
                                                                    .network(
                                                                  widget.message
                                                                      .url!
                                                                      .replaceAll(
                                                                          ".mp4",
                                                                          ".jpg"),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  colorBlendMode:
                                                                      BlendMode
                                                                          .softLight,
                                                                ), //here you can use any widget you'd like to blur .
                                                              )),
                                                      ),
                                                      widget.message.receiverDownload ==
                                                                  1 &&
                                                              widget.message
                                                                      .isDownloading ==
                                                                  false
                                                          ? Positioned.fill(
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Container(
                                                                          decoration:
                                                                              new BoxDecoration(
                                                                            color:
                                                                                Colors.black87,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                                            child:
                                                                                Icon(
                                                                              Icons.download_rounded,
                                                                              size: 30,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ))))
                                                          : Container(),
                                                      widget.message
                                                                  .receiverDownload ==
                                                              0
                                                          ? Positioned.fill(
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: !widget
                                                                          .message
                                                                          .isVideoUploading!
                                                                      ? Container(
                                                                          decoration:
                                                                              new BoxDecoration(
                                                                            color:
                                                                                Colors.black54,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(15),
                                                                            child:
                                                                                Icon(
                                                                              Icons.play_arrow,
                                                                              size: 30,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ))
                                                                      : CircularProgressIndicator(
                                                                          strokeWidth:
                                                                              3,
                                                                          valueColor:
                                                                              new AlwaysStoppedAnimation<Color>(Colors.white),
                                                                        )),
                                                            )
                                                          : Container(),
                                                      widget.message
                                                              .isDownloading!
                                                          ? Positioned.fill(
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        3,
                                                                    valueColor: new AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                  )),
                                                            )
                                                          : Container()
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : widget.message.messageType ==
                                                    "file"
                                                ? Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          child: widget.message
                                                                          .fileTypeExtension ==
                                                                      "pdf" &&
                                                                  widget.message
                                                                          .receiverDownload ==
                                                                      0
                                                              ? Container(
                                                                  height: 100,
                                                                  width: 280,
                                                                  child:
                                                                      PdfCardLocal(
                                                                    sentNow: 0,
                                                                    path: widget
                                                                        .message
                                                                        .path!,
                                                                  ),
                                                                )
                                                              : widget.message.fileTypeExtension ==
                                                                          "pdf" &&
                                                                      widget.message
                                                                              .receiverDownload ==
                                                                          1
                                                                  ? Container(
                                                                      height:
                                                                          100,
                                                                      width:
                                                                          280,
                                                                      child: Image
                                                                          .network(
                                                                        widget
                                                                            .message
                                                                            .pdfImage!,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                        ),
                                                        Container(
                                                          color: darkColor
                                                              .withOpacity(0.1),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        5),
                                                            child: Row(
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .insert_drive_file_rounded,
                                                                      color: Colors
                                                                          .red
                                                                          .shade600,
                                                                      size: 32,
                                                                    ),
                                                                    Positioned
                                                                        .fill(
                                                                      bottom: 4,
                                                                      child: Align(
                                                                          alignment: Alignment.bottomCenter,
                                                                          child: Text(
                                                                            widget.message.fileTypeExtension!.toUpperCase(),
                                                                            style:
                                                                                whiteBold.copyWith(fontSize: 9),
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                  width:
                                                                      widget.message.receiverDownload ==
                                                                              1
                                                                          ? 175
                                                                          : 200,
                                                                  child: Text(
                                                                    widget
                                                                        .message
                                                                        .fileNameUploaded!,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                widget.message
                                                                            .receiverDownload ==
                                                                        1
                                                                    ? SizedBox(
                                                                        child: widget.message.isDownloading!
                                                                            ? Container(
                                                                                child: CircularProgressIndicator(
                                                                                  strokeWidth: 0.8,
                                                                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
                                                                                ),
                                                                              )
                                                                            : Container(
                                                                                decoration: new BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  border: new Border.all(
                                                                                    color: Colors.grey,
                                                                                    width: 1,
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  child: Icon(
                                                                                    Icons.download_rounded,
                                                                                    color: Colors.grey,
                                                                                    size: 23,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : widget.message.messageType ==
                                                        "audio"
                                                    ? AudioCardReceiver(
                                                        duration: widget.message
                                                            .audioDuration,
                                                        receiverDownload: widget
                                                            .message
                                                            .receiverDownload,
                                                        receiverPath: widget
                                                            .message
                                                            .receiverDevicePath,
                                                        url: widget.message.url,
                                                        sentNow: widget
                                                            .message.sentNow,
                                                        path: widget
                                                            .message.path!,
                                                        message: widget.message,
                                                        isDownloading: widget
                                                            .message
                                                            .isDownloading,
                                                      )
                                                    : widget.message
                                                                .messageType ==
                                                            "voice"
                                                        ? VoiceCardReceiver(
                                                            path: widget.message
                                                                .receiverDevicePath!,
                                                            image: widget.image,
                                                            isSending: widget
                                                                .message
                                                                .isSending!,
                                                            duration: widget
                                                                .message
                                                                .audioDuration!,
                                                            isDownloading: widget
                                                                .message
                                                                .isDownloading!,
                                                            receiverDownload: widget
                                                                .message
                                                                .receiverDownload!,
                                                            downloadProgress:
                                                                0.0,
                                                          )
                                                        : widget.message
                                                                    .messageType ==
                                                                "contact"
                                                            ? Container(
                                                                child:
                                                                    Container(
                                                                  width: 250,
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
                                                                        child: IconButton(
                                                                            padding: const EdgeInsets.all(0.0),
                                                                            icon: Icon(
                                                                              Icons.account_circle,
                                                                              size: 50.0,
                                                                            ),
                                                                            color: darkColor,
                                                                            onPressed: () {}),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                        widget
                                                                            .message
                                                                            .contactName!,
                                                                        style: TextStyle(
                                                                            color:
                                                                                darkColor,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : widget.message
                                                                        .messageType ==
                                                                    "location"
                                                                ? Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            150,
                                                                        width:
                                                                            280,
                                                                        child: Image
                                                                            .network(
                                                                          widget
                                                                              .message
                                                                              .url!,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                      widget.message.locationTitle !=
                                                                              ""
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                                                              child: Container(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      widget.message.locationTitle!,
                                                                                      style: TextStyle(fontSize: 16, color: darkColor, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                    Text(
                                                                                      widget.message.locationSubtitle!,
                                                                                      style: TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.normal),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container()
                                                                    ],
                                                                  )
                                                                : Text(
                                                                    widget
                                                                        .message
                                                                        .message!,
                                                                    style: TextStyle(
                                                                        color: widget.message.message ==
                                                                                "This message was deleted"
                                                                            ? Colors
                                                                                .black54
                                                                            : Colors
                                                                                .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontStyle: widget.message.message ==
                                                                                "This message was deleted"
                                                                            ? FontStyle.italic
                                                                            : FontStyle.normal),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                  )
                                : widget.message.you == 2
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2),
                                        child: Container(
                                          child: Text(
                                            widget.message.message!
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        constraints: BoxConstraints(
                                          minWidth: 80.0,
                                        ),
                                        child: widget.message.messageType ==
                                                "image"
                                            ? Container(
                                                height: 300,
                                                width: 300,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 300,
                                                      width: 300,
                                                      child: Image.file(
                                                        File(widget
                                                            .message.path!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    widget.message.isSending!
                                                        ? Positioned.fill(
                                                            child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      3,
                                                                  valueColor: new AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .white),
                                                                )),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              )
                                            : widget.message.messageType ==
                                                    "video"
                                                ? Container(
                                                    height: 300,
                                                    width: 300,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 300,
                                                          width: 300,
                                                          child: Image.file(
                                                            File(widget.message
                                                                .thumbPath!),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Positioned.fill(
                                                          child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: !widget
                                                                      .message
                                                                      .isVideoUploading!
                                                                  ? Container(
                                                                      decoration:
                                                                          new BoxDecoration(
                                                                        color: Colors
                                                                            .black54,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(15),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .play_arrow,
                                                                          size:
                                                                              30,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ))
                                                                  : CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          3,
                                                                      valueColor: new AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          Colors
                                                                              .white),
                                                                    )),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : widget.message.messageType ==
                                                        "file"
                                                    ? Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10),
                                                              child: widget
                                                                          .message
                                                                          .fileTypeExtension ==
                                                                      "pdf"
                                                                  ? Container(
                                                                      height:
                                                                          100,
                                                                      width:
                                                                          280,
                                                                      child:
                                                                          PdfCardLocal(
                                                                        sentNow: widget
                                                                            .message
                                                                            .sentNow!,
                                                                        path: widget
                                                                            .message
                                                                            .thumbPath!,
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ),
                                                            Container(
                                                              color: darkColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        5),
                                                                child: Row(
                                                                  children: [
                                                                    Stack(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .insert_drive_file_rounded,
                                                                          color: Colors
                                                                              .red
                                                                              .shade600,
                                                                          size:
                                                                              32,
                                                                        ),
                                                                        Positioned
                                                                            .fill(
                                                                          bottom:
                                                                              4,
                                                                          child: Align(
                                                                              alignment: Alignment.bottomCenter,
                                                                              child: Text(
                                                                                widget.message.fileTypeExtension!.toUpperCase(),
                                                                                style: whiteBold.copyWith(fontSize: 9),
                                                                              )),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Container(
                                                                      width: widget.message.isSending ==
                                                                              true
                                                                          ? 175
                                                                          : 200,
                                                                      child:
                                                                          Text(
                                                                        widget
                                                                            .message
                                                                            .fileNameUploaded!,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    widget.message
                                                                            .isSending!
                                                                        ? CircularProgressIndicator(
                                                                            strokeWidth:
                                                                                0.8,
                                                                            valueColor:
                                                                                new AlwaysStoppedAnimation<Color>(Colors.grey),
                                                                          )
                                                                        : Container()
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : widget.message
                                                                .messageType ==
                                                            "audio"
                                                        ? AudioCardSender(
                                                            duration: widget
                                                                .message
                                                                .audioDuration!,
                                                            sentNow: widget
                                                                .message
                                                                .sentNow!,
                                                            path: widget
                                                                .message.path!,
                                                            message:
                                                                widget.message,
                                                          )
                                                        : widget.message
                                                                    .messageType ==
                                                                "voice"
                                                            ? VoiceCardSender(
                                                                path: widget
                                                                    .message
                                                                    .path!,
                                                                isSending: widget
                                                                    .message
                                                                    .isSending!,
                                                                duration: widget
                                                                    .message
                                                                    .audioDuration!,
                                                              )
                                                            : widget.message
                                                                        .messageType ==
                                                                    "contact"
                                                                ? Container(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          250,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                50.0,
                                                                            height:
                                                                                50.0,
                                                                            child: IconButton(
                                                                                padding: const EdgeInsets.all(0.0),
                                                                                icon: Icon(
                                                                                  Icons.account_circle,
                                                                                  size: 50.0,
                                                                                ),
                                                                                color: darkColor,
                                                                                onPressed: () {}),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                            widget.message.contactName!,
                                                                            style: TextStyle(
                                                                                color: darkColor,
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500),
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : widget.message
                                                                            .messageType ==
                                                                        "location"
                                                                    ? Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                150,
                                                                            width:
                                                                                280,
                                                                            child:
                                                                                Image.file(
                                                                              new File(widget.message.path!),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          widget.message.locationTitle != ""
                                                                              ? Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                                                                  child: Container(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          widget.message.locationTitle!,
                                                                                          style: TextStyle(fontSize: 16, color: darkColor, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                        Text(
                                                                                          widget.message.locationSubtitle!,
                                                                                          style: TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.normal),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : Container()
                                                                        ],
                                                                      )
                                                                    : Text(
                                                                        widget
                                                                            .message
                                                                            .message!,
                                                                        style: TextStyle(
                                                                            color: widget.message.message == "You deleted this message"
                                                                                ? Colors.black54
                                                                                : Colors.black,
                                                                            fontSize: 16,
                                                                            fontStyle: widget.message.message == "You deleted this message" ? FontStyle.italic : FontStyle.normal),
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                      ),
                                      ),
                            SizedBox(
                              height: widget.message.you == 2 ? 0 : 5,
                            ),
                            (widget.message.messageType == "image" ||
                                        widget.message.messageType ==
                                            "video") &&
                                    widget.message.message != ""
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 260.0,
                                        ),
                                        width: 260,
                                        child: Text(
                                          widget.message.message!,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize:
                                  (widget.message.messageType == "video" &&
                                              widget.message.you == 0) ||
                                          (widget.message.messageType == "file")
                                      ? MainAxisSize.max
                                      : MainAxisSize.min,
                              children: <Widget>[
                                widget.message.messageType == "video" &&
                                        widget.message.you == 0
                                    ? Row(
                                        children: [
                                          Container(
                                              child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.videocam_sharp,
                                                color: Colors.grey,
                                                size: 17,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                widget.message.you == 0
                                                    ? widget
                                                        .message.videoPlaytime!
                                                    : "",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0,
                                                ),
                                              )
                                            ],
                                          )),
                                        ],
                                      )
                                    : widget.message.messageType == "file"
                                        ? Row(
                                            children: [
                                              widget.message
                                                          .fileTypeExtension ==
                                                      "pdf"
                                                  ? Container(
                                                      color: Colors.transparent,
                                                      child: Text(
                                                        widget.message
                                                                    .pageCount ==
                                                                1
                                                            ? widget.message
                                                                    .pageCount
                                                                    .toString() +
                                                                " page"
                                                            : widget.message
                                                                    .pageCount
                                                                    .toString() +
                                                                " pages",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              widget.message
                                                          .fileTypeExtension ==
                                                      "pdf"
                                                  ? Container(
                                                      color: Colors.transparent,
                                                      child: Text(
                                                        " • ",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              Container(
                                                color: Colors.transparent,
                                                child: Text(
                                                  widget.message
                                                      .fileTypeExtension!
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : widget.message.messageType == "audio"
                                            ? Row(
                                                children: [
                                                  Container(
                                                    width: 180,
                                                    child: Text(
                                                      widget.message
                                                          .fileNameUploaded!
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12.0,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              )
                                            : widget.message.messageType ==
                                                    "voice"
                                                ? Row(
                                                    children: [
                                                      Container(
                                                        width: 180,
                                                        child: Text(
                                                          widget.message
                                                              .audioDuration!,
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12.0,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Container(),
                                                    ],
                                                  ),
                                widget.message.you != 2
                                    ? Row(
                                        children: [
                                          Container(
                                            width: 90.0,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 4.0),
                                                  child: Icon(
                                                    Icons.star,
                                                    color: Colors.grey
                                                        .withOpacity(0.6),
                                                    size: 14,
                                                  ),
                                                ),
                                                Text(
                                                  widget.message.time!
                                                      .toLowerCase(),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4.0,
                                                ),
                                                widget.message.you == 1
                                                    ? _getIcon()
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(),
                                        ],
                                      ),
                              ],
                            ),
                            widget.message.messageType == "contact"
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      widget.message.you == 1
                                          ? Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 6),
                                                  child: Container(
                                                    height: 0.3,
                                                    color: Colors.grey,
                                                    width: 250,
                                                  ),
                                                ),
                                                Text(
                                                  AppLocalizations.of("Audio"),
                                                  style: TextStyle(
                                                      color: darkColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 6),
                                                  child: Container(
                                                    height: 0.3,
                                                    color: Colors.grey,
                                                    width: 250,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 20),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                          "Message",
                                                        ),
                                                        style: TextStyle(
                                                            color: darkColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 22,
                                                      color: Colors.grey,
                                                      width: 0.3,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        print("save contact");
                                                        await ContactsService
                                                            .addContact(
                                                                new Contact(
                                                          givenName: widget
                                                              .message
                                                              .contactName,
                                                          phones: [
                                                            Item(
                                                                label: widget
                                                                    .message
                                                                    .contactType,
                                                                value: widget
                                                                    .message
                                                                    .contactNumber)
                                                          ],
                                                        )).then((value) {
                                                          customToastWhite(
                                                              AppLocalizations
                                                                  .of(
                                                                "Contact Saved Successfully",
                                                              ),
                                                              14.0,
                                                              ToastGravity
                                                                  .BOTTOM);
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                              "Add Contact",
                                                            ),
                                                            style: TextStyle(
                                                                color:
                                                                    darkColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(),
                                    ],
                                  )
                          ],
                        )),
                  ),
                ],
              ),
              Divider(thickness: 0.2, color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }

  Widget _getIcon() {
    return Icon(
      CustomIcons.double_tick_indicator,
      size: 17,
      color: Colors.grey,
    );
  }
}
