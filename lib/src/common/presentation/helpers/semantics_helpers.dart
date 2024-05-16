import 'package:flutter_ebook_app/src/common/domain/models/models.dart';

String getSemanticLabel(Entry entry, [bool? getSummary]) {
  var semanticLabel =
      "Title: '${entry.title?.t}', Author: '${entry.author?.name?.t}'";
  if (getSummary == true) {
    semanticLabel =
        '$semanticLabel, Summary: ${entry.summary!.t!.length < 100 ? entry.summary!.t! : entry.summary!.t!.substring(0, 100)}...';
  }
  return semanticLabel;
}
