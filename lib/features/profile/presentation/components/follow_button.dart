import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding on outside
      padding: const EdgeInsets.symmetric(horizontal: 25.0),

      // button
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              // Toggle the clicked state when the button is pressed
              isClicked = !isClicked;
            });
            // Call the passed in onPressed function
            widget.onPressed?.call();
          },

          // padding inside
          padding: const EdgeInsets.all(25),

          // color: Grey when clicked, otherwise the original color
          color:
              isClicked
                  ? const Color.fromARGB(
                    21,
                    158,
                    158,
                    158,
                  ) // Grey color when clicked
                  : widget.isFollowing
                  ? Theme.of(context).colorScheme.shadow
                  : Colors.blue,

          // text
          child: Text(
            widget.isFollowing ? "Unfollow" : "Follow",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ), // TextStyle
          ), // Text
        ), // MaterialButton
      ),
    ); // ClipRRect
  }
}
