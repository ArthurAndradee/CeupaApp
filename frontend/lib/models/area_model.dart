class OhsAreaDefinition {
  String id;
  String name;
  bool isPriority;
  List<String> checklist;

  OhsAreaDefinition({
    required this.id,
    required this.name,
    this.isPriority = false,
    this.checklist = const [],
  });
}