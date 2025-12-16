class Urls {
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static String registration = '$_baseUrl/Registration';
  static String signIn = '$_baseUrl/Login';
  static String createTask = '$_baseUrl/createTask';
  static String profileDetails = '$_baseUrl/ProfileDetails';
  static String newTaskList = '$_baseUrl/listTaskByStatus/New';
  static String progressTaskList = '$_baseUrl/listTaskByStatus/Progress';
  static String cancelledTaskList = '$_baseUrl/listTaskByStatus/Cancelled';
  static String completedTaskList = '$_baseUrl/listTaskByStatus/Completed';
  static String taskCountList = '$_baseUrl/taskStatusCount';
  static String updateProfile = '$_baseUrl/ProfileUpdate';
  static String recoveryResetPassword = '$_baseUrl/RecoverResetPassword';

  static String updateTaskStatus(String statusId, String status) =>
      '$_baseUrl/updateTaskStatus/$statusId/$status';

  static String emailVerify(String email) =>
      '$_baseUrl/RecoverVerifyEmail/$email';

  static String emailVerifyOTP(String email, String otp) =>
      '$_baseUrl/RecoverVerifyOtp/$email/$otp';

  static String deleteTask(String statusId) => '$_baseUrl/deleteTask/$statusId';
}
