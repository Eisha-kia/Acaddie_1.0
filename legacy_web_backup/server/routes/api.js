import express from "express";
import { courses, universityMetadata, getCourseById } from "../data/curriculum.js";
import { SimulationEngine } from "../services/simulationEngine.js";
import { HistoryStore } from "../services/historyStore.js";
import { GeminiService } from "../services/geminiService.js";
import { graphEngine } from "../services/graphEngine.js";

const router = express.Router();

// 1. Health & Engine Status
router.get("/health", (req, res) => {
  res.json({
    status: "healthy",
    product: "ACADDIE - AI-Powered Academic Change Impact Simulator",
    version: "1.0.0",
    engineMode: GeminiService.hasApiKey() ? "GEMINI_AI_REASONING_ENGINE" : "LOCAL_DETERMINISTIC_ENGINE",
    hasApiKey: GeminiService.hasApiKey(),
    timestamp: new Date().toISOString()
  });
});

// 2. Curriculum & University Data
router.get("/curriculum", (req, res) => {
  res.json({
    university: universityMetadata,
    courses,
    contradictions: graphEngine.detectContradictions(),
    confidence: graphEngine.calculateConfidence()
  });
});

// 3. Single Course Inspector
router.get("/courses/:id", (req, res) => {
  const course = getCourseById(req.params.id);
  if (!course) {
    return res.status(404).json({ error: `Course "${req.params.id}" not found.` });
  }

  const downstream = graphEngine.getDownstreamCourses(course.id);
  res.json({
    course,
    downstreamCourses: downstream
  });
});

// 4. Preloaded Judge Demo Scenarios
router.get("/demo-scenarios", (req, res) => {
  res.json([
    {
      id: "scenario-1",
      name: "Scenario 1: Remove Graph Algorithms",
      tag: "🔴 High Risk / Signature Demo",
      riskLevel: "HIGH",
      courseId: "CSE-207",
      courseName: "Data Structures",
      action: "REMOVE_TOPIC",
      topicId: "DS-6",
      topicName: "Graph Algorithms",
      facultyReason: "Course syllabus feels congested; considering offloading graphs to save 3.5 weeks.",
      description: "Faculty proposes removing Graph Algorithms from Data Structures. Triggers severe downstream disruption across Algorithms (CSE 301) and Artificial Intelligence (CSE 401), drops CLO-3 coverage, and introduces a critical curriculum gap."
    },
    {
      id: "scenario-2",
      name: "Scenario 2: Shift Machine Learning Assessment",
      tag: "🟡 Medium Risk / Balanced Re-weighting",
      riskLevel: "MEDIUM",
      courseId: "CSE-405",
      courseName: "Machine Learning",
      action: "CHANGE_ASSESSMENT",
      topicId: null,
      topicName: "Assessment Marks",
      assessmentChanges: { practical: 25 },
      facultyReason: "Industry recruiters emphasize hands-on model training over theoretical proofs.",
      description: "Faculty shifts practical assessment from 10% to 25%. Triggers lab capacity alerts, TA grading overhead, and theoretical exam compression while enhancing applied CLO attainment."
    },
    {
      id: "scenario-3",
      name: "Scenario 3: Add Python Programming to AI",
      tag: "🟢 Low Risk / Positive Enrichment",
      riskLevel: "LOW",
      courseId: "CSE-401",
      courseName: "Artificial Intelligence",
      action: "ADD_TOPIC",
      newTopicName: "Python Programming for Scientific Computing",
      newTopicWeeks: 2.0,
      facultyReason: "Modernize AI tooling with NumPy, PyTorch, and search visualization scripts.",
      description: "Faculty adds 2 weeks of hands-on Python scripting to AI. Improves student readiness for downstream Machine Learning, enhances CLO-1 attainment with zero prerequisite breakage."
    }
  ]);
});

// 5. Run Academic Impact Simulation
router.post("/simulate", async (req, res) => {
  try {
    const {
      courseId,
      action = "REMOVE_TOPIC",
      topicId,
      newTopicName,
      newTopicWeeks,
      assessmentChanges,
      targetCourseId,
      facultyReason
    } = req.body;

    if (!courseId) {
      return res.status(400).json({ error: "courseId is a mandatory parameter." });
    }

    const simulation = await SimulationEngine.runSimulation({
      courseId,
      action,
      topicId,
      newTopicName,
      newTopicWeeks,
      assessmentChanges,
      targetCourseId,
      facultyReason
    });

    // Save to persistent history store
    HistoryStore.saveSimulation(simulation);

    res.json(simulation);
  } catch (err) {
    console.error("Simulation error:", err);
    res.status(500).json({
      error: "Simulation execution failed.",
      message: err.message
    });
  }
});

// 6. Simulation History Endpoints
router.get("/history", (req, res) => {
  res.json(HistoryStore.getHistory());
});

router.get("/history/:id", (req, res) => {
  const item = HistoryStore.getSimulationById(req.params.id);
  if (!item) {
    return res.status(404).json({ error: `Simulation "${req.params.id}" not found in history.` });
  }
  res.json(item);
});

router.post("/history/:id/decision", (req, res) => {
  const { decision, notes } = req.body;
  const updated = HistoryStore.updateDecision(req.params.id, decision, notes);
  if (!updated) {
    return res.status(404).json({ error: `Simulation "${req.params.id}" not found.` });
  }
  res.json(updated);
});

export default router;
