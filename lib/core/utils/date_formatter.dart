String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Created just now';
  } else if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return 'Created $minutes minute${minutes > 1 ? 's' : ''} ago';
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    return 'Created $hours hour${hours > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 7) {
    final days = difference.inDays;
    return 'Created $days day${days > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return 'Created $weeks week${weeks > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return 'Created $months month${months > 1 ? 's' : ''} ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return 'Created $years year${years > 1 ? 's' : ''} ago';
  }
}
