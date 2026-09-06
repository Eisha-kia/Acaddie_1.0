import React from "react";
import { 
  PlusCircle, 
  Network, 
  GitCompare, 
  History, 
  Zap, 
  ShieldAlert, 
  Sliders, 
  CheckCircle2, 
  ArrowRight,
  TrendingUp,
  BookOpen,
  Layers,
  Clock
} from "lucide-react";

export default function DashboardView({ 
  curriculum, 
  history, 
  onNewSimulation, 
  onOpenMap, 
  onRunDemoScenario, 
  onReopenSimulation,
  activeSimulation
}) {
  const totalCourses = curriculum?.courses?.length || 7;
  const totalClos = curriculum?.courses?.reduce((acc, c) => acc + c.clos.length, 0) || 22;
  const totalSimulations = history?.length || 3;
  const highRiskCount = history?.filter(h => h.riskLevel === "HIGH").length || 1;

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "2.5rem" }}>
      {/* Dashboard Header */}
      <div style={{ display: "flex", alignItems: "flex-start", justifyContent: "space-between", flexWrap: "wrap", gap: "1rem" }}>
        <div>
          <span className="badge badge-blue" style={{ marginBottom: "0.5rem" }}>
            Faculty Intelligence Portal
          </span>
          <h1 style={{ fontSize: "2.25rem", marginTop: "4px" }}>Academic Decision Center</h1>
          <p style={{ fontSize: "1rem", color: "var(--text-secondary)" }}>
            Make curriculum changes with evidence, not guesswork. Think. Simulate. Decide.
          </p>
        </div>

        <div style={{ display: "flex", alignItems: "center", gap: "0.75rem", flexWrap: "wrap" }}>
          <button className="btn btn-primary" onClick={onNewSimulation}>
            <PlusCircle size={18} /> New Simulation
          </button>
          <button className="btn btn-secondary" onClick={onOpenMap}>
            <Network size={18} /> View Academic Map
          </button>
        </div>
      </div>

      {/* 4 Stats Cards */}
      <div 
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))",
          gap: "1.25rem"
        }}
      >
        <div className="card" style={{ display: "flex", alignItems: "center", gap: "1.25rem" }}>
          <div 
            style={{
              width: "48px",
              height: "48px",
              borderRadius: "var(--radius-md)",
              background: "rgba(56, 189, 248, 0.12)",
              color: "var(--accent-blue)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center"
            }}
          >
            <BookOpen size={24} />
          </div>
          <div>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-muted)" }}>
              Courses in Registry
            </div>
            <div style={{ fontSize: "1.85rem", fontWeight: 800, lineHeight: 1 }}>{totalCourses}</div>
            <div style={{ fontSize: "0.7rem", color: "var(--text-secondary)", marginTop: "2px" }}>BSc CS Core Curriculum</div>
          </div>
        </div>

        <div className="card" style={{ display: "flex", alignItems: "center", gap: "1.25rem" }}>
          <div 
            style={{
              width: "48px",
              height: "48px",
              borderRadius: "var(--radius-md)",
              background: "rgba(168, 85, 247, 0.12)",
              color: "#C084FC",
              display: "flex",
              alignItems: "center",
              justifyContent: "center"
            }}
          >
            <Layers size={24} />
          </div>
          <div>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-muted)" }}>
              Active CLO Mappings
            </div>
            <div style={{ fontSize: "1.85rem", fontWeight: 800, lineHeight: 1 }}>{totalClos}</div>
            <div style={{ fontSize: "0.7rem", color: "var(--text-secondary)", marginTop: "2px" }}>OBE Accreditation Target</div>
          </div>
        </div>

        <div className="card" style={{ display: "flex", alignItems: "center", gap: "1.25rem" }}>
          <div 
            style={{
              width: "48px",
              height: "48px",
              borderRadius: "var(--radius-md)",
              background: "rgba(16, 185, 129, 0.12)",
              color: "#34D399",
              display: "flex",
              alignItems: "center",
              justifyContent: "center"
            }}
          >
            <TrendingUp size={24} />
          </div>
          <div>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-muted)" }}>
              Simulations Run
            </div>
            <div style={{ fontSize: "1.85rem", fontWeight: 800, lineHeight: 1 }}>{totalSimulations}</div>
            <div style={{ fontSize: "0.7rem", color: "var(--text-secondary)", marginTop: "2px" }}>Recorded in History</div>
          </div>
        </div>

        <div className="card" style={{ display: "flex", alignItems: "center", gap: "1.25rem" }}>
          <div 
            style={{
              width: "48px",
              height: "48px",
              borderRadius: "var(--radius-md)",
              background: "rgba(239, 68, 68, 0.12)",
              color: "#F87171",
              display: "flex",
              alignItems: "center",
              justifyContent: "center"
            }}
          >
            <ShieldAlert size={24} />
          </div>
          <div>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-muted)" }}>
              High-Risk Flags
            </div>
            <div style={{ fontSize: "1.85rem", fontWeight: 800, lineHeight: 1 }}>{highRiskCount}</div>
            <div style={{ fontSize: "0.7rem", color: "var(--text-secondary)", marginTop: "2px" }}>Prevented by Acaddie</div>
          </div>
        </div>
      </div>

      {/* 3 Prominent Judge Demo Scenarios */}
      <div>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "1rem" }}>
          <div>
            <h3 style={{ fontSize: "1.25rem" }}>⚡ 1-Click Judge Demo Scenarios</h3>
            <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)" }}>
              Experience Acaddie's complete simulation workflow in under 2 minutes.
            </p>
          </div>
        </div>

        <div 
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(320px, 1fr))",
            gap: "1.25rem"
          }}
        >
          {/* Scenario 1 */}
          <div 
            className="card"
            style={{
              border: "1px solid rgba(239, 68, 68, 0.3)",
              background: "linear-gradient(180deg, rgba(239, 68, 68, 0.05) 0%, var(--bg-card) 100%)",
              display: "flex",
              flexDirection: "column",
              justifyContent: "space-between"
            }}
          >
            <div>
              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "0.75rem" }}>
                <span className="badge badge-high">🔴 High Risk Signature</span>
                <span style={{ fontSize: "0.75rem", color: "var(--text-muted)" }}>CSE 207 Data Structures</span>
              </div>
              <h4 style={{ fontSize: "1.1rem", marginBottom: "0.5rem" }}>
                Remove Graph Algorithms
              </h4>
              <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)", lineHeight: 1.5, marginBottom: "1.25rem" }}>
                Simulates dropping Graph Algorithms from Data Structures. Triggers severe downstream disruption across Algorithms (CSE 301) and AI (CSE 401), drops CLO-3 coverage, and introduces a curriculum gap.
              </p>
            </div>
            <button 
              className="btn btn-primary btn-sm"
              onClick={() => onRunDemoScenario("scenario-1")}
              style={{ background: "linear-gradient(135deg, #DC2626, #B91C1C)" }}
            >
              <Zap size={14} /> Run Scenario 1 Simulation <ArrowRight size={14} />
            </button>
          </div>

          {/* Scenario 2 */}
          <div 
            className="card"
            style={{
              border: "1px solid rgba(245, 158, 11, 0.3)",
              background: "linear-gradient(180deg, rgba(245, 158, 11, 0.05) 0%, var(--bg-card) 100%)",
              display: "flex",
              flexDirection: "column",
              justifyContent: "space-between"
            }}
          >
            <div>
              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "0.75rem" }}>
                <span className="badge badge-medium">🟡 Medium Risk</span>
                <span style={{ fontSize: "0.75rem", color: "var(--text-muted)" }}>CSE 405 Machine Learning</span>
              </div>
              <h4 style={{ fontSize: "1.1rem", marginBottom: "0.5rem" }}>
                Shift Practical Marks (10% ➔ 25%)
              </h4>
              <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)", lineHeight: 1.5, marginBottom: "1.25rem" }}>
                Faculty shifts practical assessment from 10% to 25%. Triggers lab capacity alerts, TA grading overhead, and theoretical exam compression while enhancing hands-on CLO attainment.
              </p>
            </div>
            <button 
              className="btn btn-primary btn-sm"
              onClick={() => onRunDemoScenario("scenario-2")}
              style={{ background: "linear-gradient(135deg, #D97706, #B45309)" }}
            >
              <Zap size={14} /> Run Scenario 2 Simulation <ArrowRight size={14} />
            </button>
          </div>

          {/* Scenario 3 */}
          <div 
            className="card"
            style={{
              border: "1px solid rgba(16, 185, 129, 0.3)",
              background: "linear-gradient(180deg, rgba(16, 185, 129, 0.05) 0%, var(--bg-card) 100%)",
              display: "flex",
              flexDirection: "column",
              justifyContent: "space-between"
            }}
          >
            <div>
              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "0.75rem" }}>
                <span className="badge badge-low">🟢 Low Risk / Positive</span>
                <span style={{ fontSize: "0.75rem", color: "var(--text-muted)" }}>CSE 401 AI</span>
              </div>
              <h4 style={{ fontSize: "1.1rem", marginBottom: "0.5rem" }}>
                Add Python Programming to AI
              </h4>
              <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)", lineHeight: 1.5, marginBottom: "1.25rem" }}>
                Faculty adds 2 weeks of hands-on Python scripting to AI. Boosts student readiness for downstream Machine Learning, enhances CLO-1 attainment with zero prerequisite breakage.
              </p>
            </div>
            <button 
              className="btn btn-primary btn-sm"
              onClick={() => onRunDemoScenario("scenario-3")}
              style={{ background: "linear-gradient(135deg, #059669, #047857)" }}
            >
              <Zap size={14} /> Run Scenario 3 Simulation <ArrowRight size={14} />
            </button>
          </div>
        </div>
      </div>

      {/* Recent Simulations Table */}
      <div className="card">
        <div className="card-header">
          <div>
            <h3 className="card-title">Recent Academic Change Simulations</h3>
            <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)", marginTop: "2px" }}>
              Audited modifications and faculty committee status.
            </p>
          </div>
        </div>

        <div style={{ overflowX: "auto" }}>
          <table className="comparison-table">
            <thead>
              <tr>
                <th>Course</th>
                <th>Proposed Modification</th>
                <th>Overall Impact</th>
                <th>Risk Level</th>
                <th>Confidence</th>
                <th>Faculty Decision</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              {history && history.length > 0 ? (
                history.map((sim, idx) => (
                  <tr key={idx}>
                    <td style={{ fontWeight: 600, color: "var(--text-primary)" }}>
                      {sim.course?.code}
                    </td>
                    <td>
                      <div style={{ fontWeight: 500 }}>
                        {sim.action.replace("_", " ")}: {sim.targetTopic?.name || "Assessment"}
                      </div>
                      <div style={{ fontSize: "0.75rem", color: "var(--text-muted)" }}>
                        {new Date(sim.timestamp).toLocaleDateString()}
                      </div>
                    </td>
                    <td>
                      <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
                        <span style={{ fontWeight: 700, fontSize: "0.95rem" }}>{sim.overallScore}</span>
                        <div 
                          style={{
                            width: "60px",
                            height: "6px",
                            borderRadius: "3px",
                            background: "rgba(255, 255, 255, 0.1)",
                            overflow: "hidden"
                          }}
                        >
                          <div 
                            style={{
                              width: `${sim.overallScore}%`,
                              height: "100%",
                              background: sim.riskLevel === "HIGH" ? "#EF4444" : sim.riskLevel === "MEDIUM" ? "#F59E0B" : "#10B981"
                            }} 
                          />
                        </div>
                      </div>
                    </td>
                    <td>
                      <span className={`badge ${sim.riskLevel === "HIGH" ? "badge-high" : sim.riskLevel === "MEDIUM" ? "badge-medium" : "badge-low"}`}>
                        {sim.riskLevel}
                      </span>
                    </td>
                    <td style={{ color: "var(--text-secondary)", fontSize: "0.85rem" }}>
                      {sim.confidence}%
                    </td>
                    <td>
                      <span 
                        style={{
                          fontSize: "0.75rem",
                          fontWeight: 600,
                          color: sim.facultyDecision === "REJECT_PROPOSAL" ? "#F87171" : sim.facultyDecision === "ACCEPT_PROPOSAL" ? "#34D399" : "#FBBF24"
                        }}
                      >
                        {sim.facultyDecision.replace(/_/g, " ")}
                      </span>
                    </td>
                    <td>
                      <button 
                        className="btn btn-secondary btn-sm"
                        onClick={() => onReopenSimulation(sim.simulationId)}
                      >
                        View Report
                      </button>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan="7" style={{ textAlign: "center", padding: "2rem", color: "var(--text-muted)" }}>
                    No simulations recorded yet. Run your first simulation above!
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
