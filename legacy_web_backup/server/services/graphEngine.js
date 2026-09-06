import { courses } from "../data/curriculum.js";

/**
 * Directed Academic Graph Engine
 * Manages relationships across courses, topics, and CLOs
 */
export class AcademicGraph {
  constructor() {
    this.courses = courses;
    this.adjacencyList = new Map(); // Course -> Downstream Courses
    this.reverseAdjacency = new Map(); // Course -> Prerequisites
    this.topicMap = new Map(); // TopicId -> { topic, courseId }
    this.cloMap = new Map(); // CloId -> { clo, courseId }
    this.topicDependencies = new Map(); // TopicId -> Set of downstream TopicIds

    this.buildGraph();
  }

  buildGraph() {
    // Initialize nodes
    this.courses.forEach(c => {
      this.adjacencyList.set(c.id, new Set());
      this.reverseAdjacency.set(c.id, new Set(c.prerequisites));

      // Index topics
      c.topics.forEach(t => {
        this.topicMap.set(t.id, { topic: t, courseId: c.id, courseName: c.name, courseCode: c.code });
        if (!this.topicDependencies.has(t.id)) {
          this.topicDependencies.set(t.id, new Set());
        }
      });

      // Index CLOs
      c.clos.forEach(clo => {
        this.cloMap.set(clo.id, { clo, courseId: c.id });
      });
    });

    // Populate course edges
    this.courses.forEach(c => {
      c.prerequisites.forEach(prereqId => {
        if (this.adjacencyList.has(prereqId)) {
          this.adjacencyList.get(prereqId).add(c.id);
        }
      });
    });

    // Populate topic dependency edges
    this.courses.forEach(c => {
      c.topics.forEach(t => {
        if (t.downstreamTopicPrereqs) {
          t.downstreamTopicPrereqs.forEach(downstreamId => {
            this.topicDependencies.get(t.id).add(downstreamId);
          });
        }
        if (t.requiresTopic) {
          if (!this.topicDependencies.has(t.requiresTopic)) {
            this.topicDependencies.set(t.requiresTopic, new Set());
          }
          this.topicDependencies.get(t.requiresTopic).add(t.id);
        }
      });
    });
  }

  /**
   * Get all downstream courses transitively affected by a given course
   * Returns an array of objects: { courseId, distance, path }
   */
  getDownstreamCourses(courseId) {
    const visited = new Set();
    const queue = [{ id: courseId, distance: 0, path: [courseId] }];
    const downstream = [];

    while (queue.length > 0) {
      const { id, distance, path } = queue.shift();

      const children = this.adjacencyList.get(id) || new Set();
      for (const childId of children) {
        if (!visited.has(childId)) {
          visited.add(childId);
          const childCourse = this.courses.find(c => c.id === childId);
          const newPath = [...path, childId];
          downstream.push({
            courseId: childId,
            courseCode: childCourse ? childCourse.code : childId,
            courseName: childCourse ? childCourse.name : childId,
            semester: childCourse ? childCourse.semester : 0,
            distance: distance + 1,
            path: newPath
          });
          queue.push({ id: childId, distance: distance + 1, path: newPath });
        }
      }
    }

    return downstream;
  }

  /**
   * Get all downstream topics that directly or indirectly depend on a topic
   */
  getDownstreamTopics(topicId) {
    const visited = new Set();
    const queue = [topicId];
    const affected = [];

    while (queue.length > 0) {
      const current = queue.shift();
      const directChildren = this.topicDependencies.get(current) || new Set();

      for (const childId of directChildren) {
        if (!visited.has(childId)) {
          visited.add(childId);
          const topicInfo = this.topicMap.get(childId);
          if (topicInfo) {
            affected.push({
              topicId: childId,
              topicName: topicInfo.topic.name,
              courseId: topicInfo.courseId,
              courseName: topicInfo.courseName,
              courseCode: topicInfo.courseCode,
              directParentId: current
            });
          }
          queue.push(childId);
        }
      }
    }

    return affected;
  }

  /**
   * Trace the exact causal path from a modified topic to downstream courses
   */
  traceCausalPath(sourceCourseId, sourceTopicId) {
    const sourceTopic = this.topicMap.get(sourceTopicId);
    if (!sourceTopic) return [];

    const downstreamTopics = this.getDownstreamTopics(sourceTopicId);
    const paths = [];

    downstreamTopics.forEach(dt => {
      paths.push({
        sourceCourse: sourceTopic.courseCode,
        sourceTopic: sourceTopic.topic.name,
        targetCourse: dt.courseCode,
        targetTopic: dt.topicName,
        explanation: `${dt.courseName} (${dt.courseCode}) relies on foundational concepts from "${sourceTopic.topic.name}" taught in ${sourceTopic.courseName}.`
      });
    });

    return paths;
  }

  /**
   * Check for curriculum contradictions (e.g., prerequisite semester >= course semester)
   */
  detectContradictions() {
    const contradictions = [];
    this.courses.forEach(c => {
      c.prerequisites.forEach(prereqId => {
        const prereqCourse = this.courses.find(p => p.id === prereqId);
        if (prereqCourse && prereqCourse.semester >= c.semester) {
          contradictions.push({
            courseId: c.id,
            courseCode: c.code,
            prereqId: prereqCourse.id,
            prereqCode: prereqCourse.code,
            issue: `Prerequisite "${prereqCourse.code}" is scheduled in Semester ${prereqCourse.semester}, which is not strictly earlier than "${c.code}" (Semester ${c.semester}).`
          });
        }
      });
    });
    return contradictions;
  }

  /**
   * Calculate graph analysis completeness / confidence score
   */
  calculateConfidence() {
    let totalConnections = 0;
    let verifiedConnections = 0;

    this.courses.forEach(c => {
      totalConnections += c.prerequisites.length;
      verifiedConnections += c.prerequisites.filter(p => this.courses.some(x => x.id === p)).length;

      c.topics.forEach(t => {
        totalConnections += 1;
        if (t.cloId && this.cloMap.has(t.cloId)) verifiedConnections += 1;
      });
    });

    const confidence = totalConnections > 0 ? Math.round((verifiedConnections / totalConnections) * 100) : 85;
    return Math.min(Math.max(confidence, 70), 98);
  }
}

export const graphEngine = new AcademicGraph();
