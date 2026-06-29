class ApiConstants {
  static const String baseUrl = 'https://zuperr-backend.onrender.com';

  // Auth
  static const String signup = '/api/employee/signup';
  static const String signin = '/api/employee/signin';
  static const String verifyOtp = '/api/employee/verifyotp';
  static const String resendOtp = '/api/employee/resendOtp';

  // Profile
  static const String getCandidateData = '/api/employee/getcandidatedata';
  static const String updateCandidateData = '/updatecandidatedata';
  static const String updateResume = '/updatecandidatedata/resume';

  // Jobs
  static const String searchJobs = '/jobs/search';
  static const String applyJob = '/auth/jobs/applyforJobs';
  static const String saveJob = '/savejob';
  static const String recommendations = '/api/employee/jobs/recommendations';

  // Dashboard
  static const String landing = '/landing';
}