class UniversityMetadata {
  final String name;
  final String shortName;
  final String department;
  final String program;
  final String curriculumVersion;

  UniversityMetadata({
    required this.name,
    required this.shortName,
    required this.department,
    required this.program,
    required this.curriculumVersion,
  });
}

class Topic {
  final String id;
  final String name;
  final double weeks;
  final String importance; // Core, Critical, Advanced
  final String cloId;
  final List<String> downstreamTopicPrereqs;
  final String? requiresTopic;

  Topic({
    required this.id,
    required this.name,
    required this.weeks,
    required this.importance,
    required this.cloId,
    this.downstreamTopicPrereqs = const [],
    this.requiresTopic,
  });
}

class CLO {
  final String id;
  final String description;
  final String bloomLevel; // Remember, Understand, Apply, Analyze, Evaluate, Create
  final double importance;

  CLO({
    required this.id,
    required this.description,
    required this.bloomLevel,
    required this.importance,
  });
}

class Course {
  final String id;
  final String code;
  final String name;
  final int semester;
  final double credit;
  final String type;
  final String description;
  final List<String> prerequisites;
  final int theoryPercentage;
  final int practicalPercentage;
  final List<CLO> clos;
  final List<Topic> topics;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.semester,
    required this.credit,
    required this.type,
    required this.description,
    required this.prerequisites,
    required this.theoryPercentage,
    required this.practicalPercentage,
    required this.clos,
    required this.topics,
  });
}

class DownstreamImpactItem {
  final String courseId;
  final String courseCode;
  final String courseName;
  final int semester;
  final int distance;
  final int impactScore;
  final String riskLevel; // HIGH, MEDIUM, LOW
  final List<String> affectedTopics;
  final String reason;

  DownstreamImpactItem({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.semester,
    required this.distance,
    required this.impactScore,
    required this.riskLevel,
    required this.affectedTopics,
    required this.reason,
  });
}

class CloImpactItem {
  final String cloId;
  final String description;
  final String bloomLevel;
  final int beforeCoverage;
  final int afterCoverage;
  final int delta;
  final String severity;
  final String explanation;

  CloImpactItem({
    required this.cloId,
    required this.description,
    required this.bloomLevel,
    required this.beforeCoverage,
    required this.afterCoverage,
    required this.delta,
    required this.severity,
    required this.explanation,
  });
}

class CurriculumGapItem {
  final String severity;
  final String concept;
  final String description;
  final String suggestedRemedy;

  CurriculumGapItem({
    required this.severity,
    required this.concept,
    required this.description,
    required this.suggestedRemedy,
  });
}

class RippleNode {
  final String nodeId;
  final String name;
  final String level; // SOURCE_CHANGE, HIGH, MEDIUM, LOW
  final String color; // crimson, amber, emerald
  final int impactScore;
  final String badge;
  final String role;
  final String details;

  RippleNode({
    required this.nodeId,
    required this.name,
    required this.level,
    required this.color,
    required this.impactScore,
    required this.badge,
    required this.role,
    required this.details,
  });
}

class AlternativePlan {
  final String id;
  final String name;
  final String tag;
  final String description;
  final int overallImpact;
  final String riskLevel;
  final bool isSafest;
  final String cloImpact;
  final String prerequisiteRisk;
  final String downstreamRisk;
  final String curriculumGap;
  final String assessmentRisk;
  final String studentReadiness;
  final List<String> pros;
  final List<String> cons;
  final String recommendationRationale;

  AlternativePlan({
    required this.id,
    required this.name,
    required this.tag,
    required this.description,
    required this.overallImpact,
    required this.riskLevel,
    this.isSafest = false,
    required this.cloImpact,
    required this.prerequisiteRisk,
    required this.downstreamRisk,
    required this.curriculumGap,
    required this.assessmentRisk,
    required this.studentReadiness,
    required this.pros,
    required this.cons,
    required this.recommendationRationale,
  });
}

class EvidencePath {
  final String fromCourse;
  final String fromTopic;
  final String relation;
  final String toCourse;
  final String toTopic;
  final String academicReason;

  EvidencePath({
    required this.fromCourse,
    required this.fromTopic,
    required this.relation,
    required this.toCourse,
    required this.toTopic,
    required this.academicReason,
  });
}

class EvidenceItem {
  final String id;
  final String dimension;
  final String evidenceType;
  final String title;
  final String summary;
  final List<EvidencePath> paths;
  final List<String> graphChain;
  final String academicStandardReference;

  EvidenceItem({
    required this.id,
    required this.dimension,
    required this.evidenceType,
    required this.title,
    required this.summary,
    required this.paths,
    required this.graphChain,
    required this.academicStandardReference,
  });
}

class SimulationResult {
  final String simulationId;
  final DateTime timestamp;
  final UniversityMetadata university;
  final Course course;
  final String action;
  final Topic? targetTopic;
  final String facultyReason;
  final int confidence;
  final int overallScore;
  final String riskLevel; // HIGH, MEDIUM, LOW
  final String riskLabel;
  final List<CloImpactItem> cloImpact;
  final int prereqScore;
  final String prereqRiskLevel;
  final String prereqSummary;
  final List<String> brokenTopics;
  final List<DownstreamImpactItem> downstreamImpact;
  final int currentTheory;
  final int currentPractical;
  final int predictedTheory;
  final int predictedPractical;
  final String assessmentExplanation;
  final List<CurriculumGapItem> curriculumGaps;
  final int readinessScore;
  final String readinessRiskLevel;
  final String readinessFriction;
  final List<RippleNode> rippleEffect;
  final List<EvidenceItem> evidenceItems;
  final List<AlternativePlan> alternatives;
  final String executiveHeadline;
  final String executiveOverall;
  final List<String> executiveRisks;
  final String recommendedAction;
  String facultyDecision;
  String facultyNotes;

  SimulationResult({
    required this.simulationId,
    required this.timestamp,
    required this.university,
    required this.course,
    required this.action,
    this.targetTopic,
    required this.facultyReason,
    required this.confidence,
    required this.overallScore,
    required this.riskLevel,
    required this.riskLabel,
    required this.cloImpact,
    required this.prereqScore,
    required this.prereqRiskLevel,
    required this.prereqSummary,
    required this.brokenTopics,
    required this.downstreamImpact,
    required this.currentTheory,
    required this.currentPractical,
    required this.predictedTheory,
    required this.predictedPractical,
    required this.assessmentExplanation,
    required this.curriculumGaps,
    required this.readinessScore,
    required this.readinessRiskLevel,
    required this.readinessFriction,
    required this.rippleEffect,
    required this.evidenceItems,
    required this.alternatives,
    required this.executiveHeadline,
    required this.executiveOverall,
    required this.executiveRisks,
    required this.recommendedAction,
    this.facultyDecision = "PENDING_FACULTY_DECISION",
    this.facultyNotes = "",
  });
}
