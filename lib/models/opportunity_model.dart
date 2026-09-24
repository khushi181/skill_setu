class OpportunityModel {
  final String id;
  final String title;
  final String company;
  final String type;
  final String location;
  final List<String> skills;
  final String qualification;
  final String compensation;
  final String description;
  final String domain;

  OpportunityModel({
    required this.id,
    required this.title,
    required this.company,
    required this.type,
    required this.location,
    required this.skills,
    required this.qualification,
    required this.compensation,
    required this.description,
    required this.domain,
  });
}