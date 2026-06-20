class CreatorOnboardingModel {
  String? role; // Singer, Dancer, Actor, etc.
  String? name;
  String? city;
  String? experienceLevel; // Beginner, Intermediate, Experienced
  List<String> primarySkills = [];
  List<String> languages = [];
  List<String> openTo = []; // Collaborations, Gigs, Full-time, Internships
  List<String> goals = [];
  String? instagramUrl;
  String? youtubeUrl;
  String? spotifyUrl;
  String? websiteUrl;

  CreatorOnboardingModel();

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'name': name,
      'city': city,
      'experience_level': experienceLevel,
      'primary_skills': primarySkills,
      'languages': languages,
      'open_to': openTo,
      'goals': goals,
      'instagram_url': instagramUrl,
      'youtube_url': youtubeUrl,
      'spotify_url': spotifyUrl,
      'website_url': websiteUrl,
    };
  }
}
