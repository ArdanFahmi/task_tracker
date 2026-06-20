import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

String getThrowErrorMsg(Object e) {
  String errorMessage = e.toString();

  // 1. Network-related errors
  if (errorMessage.contains("timeout") || errorMessage.contains("Timeout")) {
    return "Connection to the server timed out. Please try again.";
  } else if (errorMessage.contains("Failed host lookup")) {
    return "Failed to connect to the server. Please check your internet connection.";
  } else if (errorMessage.contains("connection error")) {
    return "A network connection error occurred. Please try again.";
  } else if (errorMessage.contains("connection abort")) {
    return "The connection to the server was interrupted. Please try again.";
  } else if (e is SocketException) {
    return "No internet connection. Please check your network.";
  } else if (e is TimeoutException) {
    return "Connection to the server timed out. Please try again.";
  }
  // 2. HTTP-related errors
  else if (e is HttpException) {
    return "An HTTP error occurred. Please try again.";
  }
  // 3. Data-related errors
  else if (e is FormatException) {
    return "A data format error occurred. Please try again.";
  } else if (errorMessage.contains("JSON")) {
    return "An error occurred while parsing JSON data. Please try again.";
  }
  // 4. File system-related errors
  else if (e is FileSystemException) {
    return "A file system error occurred: ${e.message}.";
  }
  // 5. SSL/TLS-related errors
  else if (errorMessage.contains("CERTIFICATE_VERIFY_FAILED")) {
    return "Insecure connection. Please check the SSL/TLS certificate.";
  } else if (errorMessage.contains("Handshake")) {
    return "Connection failed during SSL/TLS handshake. Please check your secure connection.";
  }
  // 6. Permission-related errors
  else if (errorMessage.contains("Permission denied")) {
    return "Permission denied. Please check your app settings.";
  }
  // 7. Server-related errors
  else if (errorMessage.contains("500")) {
    return "The server is currently experiencing issues. Please try again later.";
  } else if (errorMessage.contains("404")) {
    return "Server not found. Please check the URL or your connection.";
  } else if (errorMessage.contains("403")) {
    return "Access denied. You do not have the necessary permissions.";
  }
  // 8. Supabase errors
  else if (e is AuthApiException) {
    if (e.message.contains("Invalid login credentials")) {
      return "Incorrect email or password.";
    } else if (e.message.contains("User already registered")) {
      return "An account with this email is already registered.";
    } else if (e.message.contains("Email not confirmed")) {
      return "Email not confirmed. Please check your inbox.";
    } else {
      return "An authentication error occurred. Please try again.";
    }
  } else if (e is PostgrestException) {
    return getPostgresErrorMessage(e.code ?? '');
  }
  // 9. Unknown or uncategorized errors
  else {
    // Logging unhandled error for developers
    return "[Unknown Error] $errorMessage. Please try again.";
  }
}

String getPostgresErrorMessage(String code) {
  switch (code) {
    case '22P02':
      return "Invalid data format. Please check your input.";
    case '23505':
      return "The data already exists.";
    case '23503':
      return "Related data not found.";
    case '23502':
      return "A required field is missing.";
    case '22001':
      return "The data exceeds the allowed length.";
    default:
      return "An error occurred while processing the data.";
  }
}
