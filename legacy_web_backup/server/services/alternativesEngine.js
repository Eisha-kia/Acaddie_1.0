/**
 * Alternatives Engine: Synthesizes Plan A (Proposed), Plan B (Tuned/Reduced),
 * and Plan C (Relocation/Restructuring) for side-by-side What-If comparison.
 */

export class AlternativesEngine {
  static generateAlternatives(course, topic, action, simulationResult) {
    if (action === "REMOVE_TOPIC" || action === "remove_topic") {
      const planA = {
        id: "plan-a",
        name: "Plan A: Proposed Full Removal",
        tag: "Proposed Action",
        description: `Permanently delete "${topic.name}" from ${course.code}.`,
        overallImpact: simulationResult.overallScore,
        riskLevel: simulationResult.riskLevel,
        riskColor: simulationResult.riskColor,
        cloImpact: "High (Severe coverage drop)",
        prerequisiteRisk: "High (Multiple downstream topics broken)",
        downstreamRisk: "High (Algorithms & AI affected)",
        curriculumGap: "High (Critical traversal concepts untaught)",
        assessmentRisk: "Medium (Marks shifted to other topics)",
        studentReadiness: "High (Incoming cohort lacking fundamentals)",
        pros: [
          `Frees up ${topic.weeks} weeks in ${course.code} for existing topics.`,
          "Reduces initial student cognitive overload in early semester."
        ],
        cons: [
          "Creates severe downstream knowledge gaps in Algorithms and AI.",
          "Breaks CLO-3 accreditation alignment.",
          "Faculty in downstream courses will need to teach prerequisite concepts from scratch."
        ],
        recommendationRationale: "Not recommended as-is due to high cascade risk across 3 subsequent semesters."
      };

      const planB = {
        id: "plan-b",
        name: "Plan B: Scope Reduction (Essential Subset)",
        tag: "Recommended Compromise",
        description: `Retain core concepts of "${topic.name}" (BFS/DFS, Representations) but reduce instructional time from ${topic.weeks} weeks to 1.5 weeks. Omit advanced topics like Minimum Spanning Trees and Bellman-Ford.`,
        overallImpact: 42,
        riskLevel: "MEDIUM",
        riskColor: "amber",
        cloImpact: "Medium (Essential concepts preserved)",
        prerequisiteRisk: "Medium (Basic traversal preserved; advanced topics deferred)",
        downstreamRisk: "Medium (Algorithms can build on basic BFS/DFS)",
        curriculumGap: "Low (Core foundations intact)",
        assessmentRisk: "Low (Minor re-weighting)",
        studentReadiness: "Medium (Students know basic data structures)",
        pros: [
          `Frees 2.0 weeks of instructional time in ${course.code}.`,
          "Preserves prerequisite readiness for CSE 301 Algorithms.",
          "Students maintain exposure to fundamental graph search algorithms."
        ],
        cons: [
          "Leaves less time for hands-on programming projects on graphs.",
          "Slightly compresses coverage of Dijkstra's algorithm."
        ],
        recommendationRationale: "Provides a balanced compromise: reduces syllabus congestion while preserving necessary prerequisite readiness."
      };

      const planC = {
        id: "plan-c",
        name: "Plan C: Curricular Relocation (Move to Algorithms)",
        tag: "Lowest Modeled Impact",
        isSafest: true,
        description: `Move the in-depth treatment of "${topic.name}" to CSE 301 (Algorithms), while keeping only a 1-week conceptual overview in ${course.code}. Formally update the CSE 301 course syllabus and credits accordingly.`,
        overallImpact: 26,
        riskLevel: "LOW",
        riskColor: "emerald",
        cloImpact: "Low (CLO re-allocated to CSE 301)",
        prerequisiteRisk: "Low (Taught at the immediate point of need in Algorithms)",
        downstreamRisk: "Low (Algorithms syllabus absorbs and structures the topic)",
        curriculumGap: "Low (Zero net loss in curriculum-wide knowledge)",
        assessmentRisk: "Low (Harmonized across semesters)",
        studentReadiness: "Low (Continuously reinforced in algorithmic context)",
        pros: [
          "Zero total knowledge loss across the degree program.",
          "Allows Graph Algorithms to be taught with greater mathematical maturity in Semester 4.",
          "Eliminates conceptual redundancy between Data Structures and Algorithms."
        ],
        cons: [
          "Requires coordinated syllabus approval across two faculty instructors.",
          "CSE 301 syllabus will need 2 additional weeks of instructional time."
        ],
        recommendationRationale: "Model indicates lowest structural risk (26/100). Foundational concepts remain in the degree program without breaking downstream courses."
      };

      return [planA, planB, planC];
    } else if (action === "CHANGE_ASSESSMENT" || action === "change_assessment") {
      const planA = {
        id: "plan-a",
        name: "Plan A: Proposed Mark Shift",
        tag: "Proposed Action",
        description: "Increase practical assessment from 10% to 25%, decreasing theory marks from 90% to 75%.",
        overallImpact: simulationResult.overallScore,
        riskLevel: simulationResult.riskLevel,
        riskColor: simulationResult.riskColor,
        cloImpact: "Low (CLO alignment is preserved)",
        prerequisiteRisk: "Low (Content remains unchanged)",
        downstreamRisk: "Low (No topics removed)",
        curriculumGap: "Low (Zero knowledge gaps)",
        assessmentRisk: "Medium (Lab infrastructure and grading load increase)",
        studentReadiness: "Low (Enhanced hands-on coding ability)",
        pros: [
          "Significantly improves hands-on implementation capabilities of students.",
          "Aligns with modern industry demands for machine learning engineering."
        ],
        cons: [
          "Requires additional teaching assistant hours for code evaluation.",
          "Increases lab computer equipment workload."
        ],
        recommendationRationale: "A constructive change with moderate operational impact on departmental resources."
      };

      const planB = {
        id: "plan-b",
        name: "Plan B: Phased Increase (10% ➔ 18%)",
        tag: "Balanced Feasibility",
        isSafest: true,
        description: "Moderate practical increase to 18% with peer-reviewed lab assignments to minimize faculty grading burden.",
        overallImpact: 22,
        riskLevel: "LOW",
        riskColor: "emerald",
        cloImpact: "Low",
        prerequisiteRisk: "Low",
        downstreamRisk: "Low",
        curriculumGap: "Low",
        assessmentRisk: "Low",
        studentReadiness: "Low (Positive)",
        pros: [
          "Boosts hands-on learning without overburdening grading staff.",
          "Can be implemented immediately within current lab schedules."
        ],
        cons: [
          "Smaller practical boost than Plan A."
        ],
        recommendationRationale: "Lowest operational friction while still improving practical learning outcomes."
      };

      const planC = {
        id: "plan-c",
        name: "Plan C: Add Dedicated Lab Component (1.5 Credit Lab)",
        tag: "Long-Term Structural Fix",
        description: "Separate the practical component into an autonomous sessional course (CSE 406: Machine Learning Lab, 1.5 credits).",
        overallImpact: 35,
        riskLevel: "MEDIUM",
        riskColor: "amber",
        cloImpact: "Positive Enrichment",
        prerequisiteRisk: "Low",
        downstreamRisk: "Low",
        curriculumGap: "Low",
        assessmentRisk: "Medium (Requires curriculum revision)",
        studentReadiness: "Positive (Highest practical readiness)",
        pros: [
          "Best pedagogical separation of theory and practical experimentation.",
          "Standard academic structure in leading CS programs."
        ],
        cons: [
          "Requires Academic Council approval for adding a new course code."
        ],
        recommendationRationale: "Pedagogically superior but requires formal committee approval."
      };

      return [planA, planB, planC];
    } else {
      // Default generic / Add Topic comparison
      return [
        {
          id: "plan-a",
          name: "Plan A: Full Implementation",
          tag: "Proposed Action",
          description: "Implement the requested change in full for the upcoming academic session.",
          overallImpact: simulationResult.overallScore,
          riskLevel: simulationResult.riskLevel,
          riskColor: simulationResult.riskColor,
          cloImpact: "Positive Enrichment",
          prerequisiteRisk: "Low",
          downstreamRisk: "Low",
          curriculumGap: "Low",
          assessmentRisk: "Low",
          studentReadiness: "Positive",
          pros: ["Modernizes curriculum with in-demand competencies."],
          cons: ["May cause minor syllabus overload if no other topic is trimmed."],
          recommendationRationale: "Constructive modification with low structural risk."
        },
        {
          id: "plan-b",
          name: "Plan B: Modular Integration (Self-Paced / Pre-requisite Module)",
          tag: "Low Workload Alternative",
          isSafest: true,
          description: "Offer the new topic as an introductory 1-week module with optional self-paced tutorials.",
          overallImpact: 18,
          riskLevel: "LOW",
          riskColor: "emerald",
          cloImpact: "Low",
          prerequisiteRisk: "Low",
          downstreamRisk: "Low",
          curriculumGap: "Low",
          assessmentRisk: "Low",
          studentReadiness: "Positive",
          pros: ["Zero displacement of existing topics.", "Immediate adoption."],
          cons: ["Less formal graded assessment."],
          recommendationRationale: "Safest integration path that avoids displacing existing core topics."
        }
      ];
    }
  }
}
