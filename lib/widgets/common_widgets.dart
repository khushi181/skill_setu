import 'package:flutter/material.dart';


// ------------------------------------
// SECTION TITLE
// ------------------------------------

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 10,
      bottom: 10,
    ),

    child: Text(
      title,

      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}


// ------------------------------------
// STAT CARD
// ------------------------------------

Widget statCard(
  String title,
  String value,
  IconData icon,
) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(14),

      child: Row(
        children: [

          CircleAvatar(
            child: Icon(icon),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Text(
                  title,

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


// ------------------------------------
// MESSAGE
// ------------------------------------

void showAppMessage(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}