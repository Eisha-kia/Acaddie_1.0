/**
 * Explainable Multi-factor Impact Scoring Engine
 * Weighted scoring model that generates mathematically transparent scores and risk levels.
 */

export const SCORING_WEIGHTS = {
  cloImpact: 0.30,         // 30%
  prerequisiteRisk: 0.25,  // 25%
  downstreamImpact: 0.20,  // 20%
  assessmentImpact: 0.10,  // 10%
  curriculumGap: 0.10,     // 10%
  courseOverlap: 0.05      // 5%
};

export class ScoringEngine {
  /**
   * Calculates overall impact (0-100), risk category, and sub-score details
   */
  static calculateOverallScore(dimensionScores) {
    const {
      cloScore = 0,
      prereqScore = 0,
      downstreamScore = 0,
      assessmentScore = 0,
      gapScore = 0,
      overlapScore = 0
    } = dimensionScores;

    const weightedScore = Math.round(
      cloScore * SCORING_WEIGHTS.cloImpact +
      prereqScore * SCORING_WEIGHTS.prerequisiteRisk +
      downstreamScore * SCORING_WEIGHTS.downstreamImpact +
      assessmentScore * SCORING_WEIGHTS.assessmentImpact +
      gapScore * SCORING_WEIGHTS.curriculumGap +
      overlapScore * SCORING_WEIGHTS.courseOverlap
    );

    const boundedScore = Math.max(0, Math.min(100, weightedScore));

    let riskLevel = "LOW";
    let riskColor = "emerald";
    let riskLabel = "Low Risk / Minimal Disruption";

    if (boundedScore > 60) {
      riskLevel = "HIGH";
      riskColor = "crimson";
      riskLabel = "High Risk / Critical Curriculum Disruption";
    } else if (boundedScore > 30) {
      riskLevel = "MEDIUM";
      riskColor = "amber";
      riskLabel = "Medium Risk / Moderate Impact";
    }

    const breakdown = [
      {
        name: "CLO Impact",
        score: cloScore,
        weight: "30%",
        weightedContribution: Math.round(cloScore * SCORING_WEIGHTS.cloImpact * 10) / 10,
        description: "Measures loss or degradation in mapped Course Learning Outcomes."
      },
      {
        name: "Prerequisite Risk",
        score: prereqScore,
        weight: "25%",
        weightedContribution: Math.round(prereqScore * SCORING_WEIGHTS.prerequisiteRisk * 10) / 10,
        description: "Evaluates broken foundational readiness for directly dependent courses."
      },
      {
        name: "Downstream Course Impact",
        score: downstreamScore,
        weight: "20%",
        weightedContribution: Math.round(downstreamScore * SCORING_WEIGHTS.downstreamImpact * 10) / 10,
        description: "Measures transitive ripple effects through the university curriculum graph."
      },
      {
        name: "Curriculum Gap Detection",
        score: gapScore,
        weight: "10%",
        weightedContribution: Math.round(gapScore * SCORING_WEIGHTS.curriculumGap * 10) / 10,
        description: "Identifies core academic competencies left completely untaught."
      },
      {
        name: "Assessment Balance Impact",
        score: assessmentScore,
        weight: "10%",
        weightedContribution: Math.round(assessmentScore * SCORING_WEIGHTS.assessmentImpact * 10) / 10,
        description: "Detects shifts between theoretical rigor and practical laboratory hours."
      },
      {
        name: "Course Overlap & Placement",
        score: overlapScore,
        weight: "5%",
        weightedContribution: Math.round(overlapScore * SCORING_WEIGHTS.courseOverlap * 10) / 10,
        description: "Analyzes redundant duplication or misplaced topics across academic semesters."
      }
    ];

    return {
      overallScore: boundedScore,
      riskLevel,
      riskColor,
      riskLabel,
      breakdown,
      formula: "Overall = (CLO × 0.30) + (Prereq × 0.25) + (Downstream × 0.20) + (Gap × 0.10) + (Assessment × 0.10) + (Overlap × 0.05)"
    };
  }
}
