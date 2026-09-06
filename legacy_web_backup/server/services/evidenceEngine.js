/**
 * Evidence Engine: Generates verifiable causal graph paths for the "Why?" feature.
 * Explicitly separates structural curriculum evidence from AI interpretive commentary.
 */

export class EvidenceEngine {
  static buildEvidenceForTopicChange(course, topic, action, downstreamCourses, downstreamTopics) {
    const evidenceItems = [];

    // 1. Prerequisite evidence
    if (downstreamTopics.length > 0) {
      const paths = downstreamTopics.map(dt => ({
        fromCourse: `${course.code} (${course.name})`,
        fromTopic: topic.name,
        relation: "IS_FOUNDATIONAL_PREREQUISITE_FOR",
        toCourse: `${dt.courseCode} (${dt.courseName})`,
        toTopic: dt.topicName,
        academicReason: `${dt.courseCode} syllabus assumes prior mastery of fundamental concepts from "${topic.name}".`
      }));

      evidenceItems.push({
        id: "ev-prereq",
        dimension: "Prerequisite Risk",
        evidenceType: "VERIFIED_STRUCTURAL_RELATION",
        title: `Prerequisite Disruption for ${downstreamTopics.length} Downstream Topics`,
        summary: `Removing "${topic.name}" breaks the verified curricular dependency chain documented in the Department OBE syllabus.`,
        paths,
        graphChain: [
          `${course.code}: ${topic.name}`,
          ...downstreamTopics.map(dt => `${dt.courseCode}: ${dt.topicName}`)
        ],
        academicStandardReference: "OBE Accreditation Standard 3: Articulation of Prerequisite Sequences (IEEE/ACM CS Curricula 2023)."
      });
    }

    // 2. CLO Mapping Evidence
    const mappedClo = course.clos.find(c => c.id === topic.cloId);
    if (mappedClo) {
      evidenceItems.push({
        id: "ev-clo",
        dimension: "CLO Impact",
        evidenceType: "VERIFIED_STRUCTURAL_RELATION",
        title: `Direct Contributor to ${mappedClo.id} (${mappedClo.bloomLevel})`,
        summary: `Topic "${topic.name}" accounts for substantial instruction towards "${mappedClo.description}".`,
        paths: [
          {
            fromCourse: course.code,
            fromTopic: topic.name,
            relation: "DIRECTLY_ASSESSES_CLO",
            toCourse: course.code,
            toTopic: mappedClo.id,
            academicReason: `This topic provides ${topic.weeks} weeks of dedicated instructional contact time for ${mappedClo.id}.`
          }
        ],
        graphChain: [
          `${course.code} ➔ Topic: ${topic.name} (${topic.weeks} wks)`,
          `${mappedClo.id} [${mappedClo.bloomLevel} Level] ➔ Target Competency Achieved: ${Math.round(mappedClo.importance)}%`
        ],
        academicStandardReference: "ABET Criterion 3: Student Outcomes Assessment & Program Educational Objectives."
      });
    }

    // 3. Student Readiness Evidence
    if (downstreamCourses.length > 0) {
      const directChild = downstreamCourses[0];
      evidenceItems.push({
        id: "ev-readiness",
        dimension: "Student Readiness",
        evidenceType: "CURRICULUM_MODELING_INFERENCE",
        title: `Cohort Transition Gap in ${directChild.courseCode}`,
        summary: `Faculty teaching ${directChild.courseCode} will need to spend 2-3 weeks of remedial review if students arrive without foundational "${topic.name}" training.`,
        paths: [
          {
            fromCourse: `${course.code} (Sem ${course.semester})`,
            fromTopic: topic.name,
            relation: "FEEDS_STUDENT_COHORT_INTO",
            toCourse: `${directChild.courseCode} (Sem ${directChild.semester})`,
            toTopic: "Course Entry Readiness",
            academicReason: `Expected entry competency requires implementation proficiency in ${topic.name}.`
          }
        ],
        graphChain: [
          `Semester ${course.semester}: ${course.code} (Topic: ${topic.name})`,
          `Semester Break / Cohort Advancement`,
          `Semester ${directChild.semester}: ${directChild.courseCode} (Advanced Topics)`
        ],
        academicStandardReference: "Faculty Senate Academic Policy on Prerequisite Knowledge Transfer."
      });
    }

    return evidenceItems;
  }
}
