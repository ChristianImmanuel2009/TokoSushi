import 'package:flutter/material.dart';


class AlertMessage {
  showAlert(BuildContext context, String message, bool isSuccess) {

    final Color backgroundColor = isSuccess ? Colors.green : Colors.red;  
    final Color borderColor = isSuccess ? Colors.greenAccent : Colors.redAccent;
    final IconData icon = isSuccess ? Icons.check_circle : Icons.error;
    final Color iconColor = isSuccess ? Colors.white : Colors.white;

    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500),
              ),            
            ),
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.close, size:20, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            )
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
  }
}