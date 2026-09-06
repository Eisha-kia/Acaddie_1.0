import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const HISTORY_FILE = path.join(__dirname, "../data/history.json");

// Default initial history items so the history page is never empty
const DEFAULT_HISTORY = [
  {
    simulationId: "sim-hist-001",
    timestamp: "2026-09-04T14:20:00.000Z",
    course: { id: "CSE-207", code: "CSE 207", name: "Data Structures" },
    action: "REMOVE_TOPIC",
    targetTopic: { id: "DS-6", name: "Graph Algorithms", weeks: 3.5 },
    overallScore: 78,
    riskLevel: "HIGH",
    riskColor: "crimson",
    confidence: 94,
    facultyDecision: "REJECT_PROPOSAL",
    facultyNotes: "Curriculum committee voted to retain Graph Algorithms in CSE 207 due to severe downstream ripple on Algorithms and AI.",
    summary: "Simulated removal of Graph Algorithms. High risk detected across CLO-3, Algorithms (CSE 301), and Artificial Intelligence (CSE 401)."
  },
  {
    simulationId: "sim-hist-002",
    timestamp: "2026-09-05T09:15:00.000Z",
    course: { id: "CSE-405", code: "CSE 405", name: "Machine Learning" },
    action: "CHANGE_ASSESSMENT",
    targetTopic: { id: null, name: "Assessment Mark Re-weighting", weeks: 0 },
    overallScore: 42,
    riskLevel: "MEDIUM",
    riskColor: "amber",
    confidence: 92,
    facultyDecision: "ACCEPT_PROPOSAL",
    facultyNotes: "Approved phased rollout to expand practical projects to 20% to foster hands-on coding skills.",
    summary: "Shifted practical assessment from 10% to 25%. Medium operational risk on lab infrastructure."
  },
  {
    simulationId: "sim-hist-003",
    timestamp: "2026-09-05T16:45:00.000Z",
    course: { id: "CSE-401", code: "CSE 401", name: "Artificial Intelligence" },
    action: "ADD_TOPIC",
    targetTopic: { id: null, name: "Python Programming for Scientific Computing", weeks: 2 },
    overallScore: 22,
    riskLevel: "LOW",
    riskColor: "emerald",
    confidence: 96,
    facultyDecision: "ACCEPT_PROPOSAL",
    facultyNotes: "Adopted for upcoming 2026 Spring term. Synchronized with CSE 405.",
    summary: "Added 2 weeks of Python scripting to AI. Positive enrichment observed for Machine Learning readiness."
  }
];

export class HistoryStore {
  static getHistory() {
    try {
      if (!fs.existsSync(HISTORY_FILE)) {
        fs.writeFileSync(HISTORY_FILE, JSON.stringify(DEFAULT_HISTORY, null, 2));
        return DEFAULT_HISTORY;
      }
      const data = fs.readFileSync(HISTORY_FILE, "utf-8");
      return JSON.parse(data);
    } catch (err) {
      console.error("Error reading history store:", err);
      return DEFAULT_HISTORY;
    }
  }

  static saveSimulation(simulation) {
    try {
      const history = this.getHistory();
      const historyEntry = {
        simulationId: simulation.simulationId,
        timestamp: simulation.timestamp,
        course: simulation.course,
        action: simulation.action,
        targetTopic: simulation.targetTopic,
        overallScore: simulation.overallScore,
        riskLevel: simulation.riskLevel,
        riskColor: simulation.riskColor,
        confidence: simulation.confidence,
        facultyDecision: simulation.facultyControl?.status || "PENDING_FACULTY_DECISION",
        facultyNotes: simulation.facultyControl?.notes || "",
        summary: simulation.executiveSummary?.headline || "Curriculum impact simulation complete.",
        fullData: simulation
      };

      const updated = [historyEntry, ...history.filter(h => h.simulationId !== simulation.simulationId)];
      fs.writeFileSync(HISTORY_FILE, JSON.stringify(updated.slice(0, 50), null, 2));
      return historyEntry;
    } catch (err) {
      console.error("Error saving simulation:", err);
      return null;
    }
  }

  static updateDecision(simulationId, decision, notes) {
    try {
      const history = this.getHistory();
      const item = history.find(h => h.simulationId === simulationId);
      if (item) {
        item.facultyDecision = decision;
        if (notes !== undefined) item.facultyNotes = notes;
        if (item.fullData && item.fullData.facultyControl) {
          item.fullData.facultyControl.status = decision;
          item.fullData.facultyControl.notes = notes;
        }
        fs.writeFileSync(HISTORY_FILE, JSON.stringify(history, null, 2));
        return item;
      }
      return null;
    } catch (err) {
      console.error("Error updating decision:", err);
      return null;
    }
  }

  static getSimulationById(simulationId) {
    const history = this.getHistory();
    const item = history.find(h => h.simulationId === simulationId);
    return item ? (item.fullData || item) : null;
  }
}
