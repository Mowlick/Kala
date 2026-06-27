import 'package:flutter/material.dart';
import '../data/models/creator_onboarding_model.dart';

class OnboardingController extends ChangeNotifier {
  final CreatorOnboardingModel _model = CreatorOnboardingModel();
  
  CreatorOnboardingModel get model => _model;

  // Onboarding Step helper (1 to 4)
  int _currentStep = 1;
  int get currentStep => _currentStep;

  void nextStep(BuildContext context, String nextRoute) {
    if (_currentStep < 4) {
      _currentStep++;
      notifyListeners();
    }
    Navigator.pushNamed(context, nextRoute);
  }

  void prevStep(BuildContext context) {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
    Navigator.pop(context);
  }

  void resetSteps() {
    _currentStep = 1;
    notifyListeners();
  }

  // Setters for each step
  void setRoles(List<String> roles) {
    _model.roles = roles;
    notifyListeners();
  }

  void updateDetails({
    required String name,
    required String city,
    required String experienceLevel,
    required List<String> primarySkills,
    required List<String> languages,
    required List<String> openTo,
  }) {
    _model.name = name;
    _model.city = city;
    _model.experienceLevel = experienceLevel;
    _model.primarySkills = primarySkills;
    _model.languages = languages;
    _model.openTo = openTo;
    notifyListeners();
  }

  void toggleGoal(String goal) {
    if (_model.goals.contains(goal)) {
      _model.goals.remove(goal);
    } else {
      _model.goals.add(goal);
    }
    notifyListeners();
  }

  void updatePortfolioLinks({
    String? instagram,
    String? youtube,
    String? spotify,
    String? website,
  }) {
    _model.instagramUrl = instagram;
    _model.youtubeUrl = youtube;
    _model.spotifyUrl = spotify;
    _model.websiteUrl = website;
    notifyListeners();
  }
}
