import React, { useState } from "react";
import { 
  ShieldAlert, 
  ShieldCheck, 
  HelpCircle, 
  ArrowRight, 
  GitCompare, 
  Network, 
  FileText, 
  CheckCircle2, 
  AlertTriangle, 
  BookOpen, 
  Layers, 
  TrendingDown, 
  TrendingUp,
  Sliders,
  Sparkles
} from "lucide-react";

export default function ImpactReportView({ 
  simulation, 
  onViewOnMap, 
  onComparePlans, 
  onExportReport, 
  onOpenEvidence,
  onSaveFacultyDecision 
}) {
  if (!simulation) {
    return <div className="card">No simulation data available.</div>;
  }

  const [activeTab, setActiveTab] = useState("clo");
  const [showFormulaModal, setShowFormulaModal] = useState(false);
  const [facultyDecision, setFacultyDecision] = useState(simulation.facultyControl?.status || "PENDING_FACULTY_DECISION");
  const [facultyNotes, setFacultyNotes] = useState(simulation.facultyControl?.notes || "");
  const [saveSuccess, setSaveSuccess] = useState(false);

  const handleDecisionSave = () => {
    onSaveFacultyDecision(simulation.simulationId, facultyDecision, facultyNotes);
    setSaveSuccess(true);
    setTimeout(() => setSaveSuccess(false), 3000);
  };

  const riskClass = simulation.riskLevel.toLowerCase();

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "2rem" }}>
      {/* Top Action Bar */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", flexWrap: "wrap", gap: "1rem" }}>
        <div>
          <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
            <span className="badge badge-blue">{simulation.course?.code}</span>
            <span className={`badge badge-${riskClass}`}>
              {simulation.riskLevel} IMPACT ({simulation.overallScore}/100)
            </span>
            <span className="badge" style={{ background: "rgba(255, 255, 255, 0.08)", color: "var(--text-secondary)" }}>
              Confidence: {simulation.confidence}%
            </span>
          </div>
          <h1 style={{ fontSize: "2rem", marginTop: "4px" }}>Academic Change Impact Report</h1>
          <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)" }}>
            Simulation ID: <code style={{ color: "var(--accent-blue)" }}>{simulation.simulationId}</code> • Generated: {new Date(simulation.timestamp).toLocaleString()}
          </p>
        </div>

        <div style={{ display: "flex", alignItems: "center", gap: "0.75rem", flexWrap: "wrap" }}>
          <button className="btn btn-secondary" onClick={onViewOnMap}>
            <Network size={16} /> View Ripple on Map
          </button>
          <button className="btn btn-secondary" onClick={onComparePlans}>
            <GitCompare size={16} /> Compare Plans
          </button>
          <button className="btn btn-primary" onClick={onExportReport}>
            <FileText size={16} /> Export Official Report
          </button>
        </div>
      </div>

      {/* Engine Mode Banner */}
      <div 
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          padding: "0.75rem 1.25rem",
          borderRadius: "var(--radius-md)",
          background: simulation.aiEnrichment?.isAiEnriched ? "rgba(99, 102, 241, 0.1)" : "rgba(16, 185, 129, 0.1)",
          border: `1px solid ${simulation.aiEnrichment?.isAiEnriched ? "rgba(99, 102, 241, 0.3)" : "rgba(16, 185, 129, 0.3)"}`
        }}
      >
        <div style={{ display: "flex", alignItems: "center", gap: "0.6rem" }}>
          <Sparkles size={16} color={simulation.aiEnrichment?.isAiEnriched ? "#A5B4FC" : "#34D399"} />
          <span style={{ fontSize: "0.85rem", fontWeight: 600, color: "var(--text-primary)" }}>
            Active Engine: {simulation.aiEnrichment?.engineBadge}
          </span>
        </div>
        <span style={{ fontSize: "0.75rem", color: "var(--text-secondary)" }}>
          {simulation.aiEnrichment?.aiNotes || "Contextual LLM reasoning layer enabled."}
        </span>
      </div>

      {/* Executive Briefing Card & Score Gauge */}
      <div 
        style={{
          display: "grid",
          gridTemplateColumns: "260px 1fr",
          gap: "1.5rem",
          alignItems: "stretch"
        }}
      >
        {/* Score Gauge */}
        <div className="card" style={{ display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", textAlign: "center" }}>
          <div className={`score-circle ${riskClass}`} style={{ marginBottom: "1rem" }}>
            <span className="score-number">{simulation.overallScore}</span>
            <span className="score-label">/ 100</span>
          </div>
          <span className={`badge badge-${riskClass}`} style={{ marginBottom: "0.5rem" }}>
            {simulation.riskLevel} RISK
          </span>
          <div style={{ fontSize: "0.75rem", color: "var(--text-secondary)", marginBottom: "0.75rem" }}>
            {simulation.riskLabel}
          </div>
          <button 
            className="btn btn-secondary btn-sm"
            onClick={() => setShowFormulaModal(true)}
            style={{ fontSize: "0.75rem", padding: "0.25rem 0.65rem" }}
          >
            <HelpCircle size={12} /> How is this calculated?
          </button>
        </div>

        {/* Executive Summary */}
        <div className="card" style={{ display: "flex", flexDirection: "column", justifyContent: "space-between" }}>
          <div>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "var(--accent-blue)", marginBottom: "0.4rem" }}>
              Executive Briefing for Faculty &amp; Curriculum Committee
            </div>
            <h3 style={{ fontSize: "1.25rem", marginBottom: "0.75rem", lineHeight: 1.4 }}>
              {simulation.executiveSummary?.headline}
            </h3>
            <p style={{ fontSize: "0.9rem", color: "var(--text-secondary)", lineHeight: 1.6, marginBottom: "1rem" }}>
              {simulation.executiveSummary?.overallAssessment}
            </p>

            {/* Key Risks Checklist */}
            <div style={{ display: "flex", flexDirection: "column", gap: "0.4rem" }}>
              {simulation.executiveSummary?.keyRisks?.map((risk, idx) => (
                <div key={idx} style={{ display: "flex", alignItems: "flex-start", gap: "0.5rem", fontSize: "0.85rem" }}>
                  <AlertTriangle size={15} color="#EF4444" style={{ flexShrink: 0, marginTop: "3px" }} />
                  <span style={{ color: "var(--text-primary)" }}>{risk}</span>
                </div>
              ))}
            </div>
          </div>

          <div 
            style={{
              marginTop: "1.25rem",
              padding: "0.75rem 1rem",
              background: "rgba(56, 189, 248, 0.08)",
              border: "1px solid rgba(56, 189, 248, 0.25)",
              borderRadius: "var(--radius-sm)",
              fontSize: "0.85rem",
              color: "#93C5FD"
            }}
          >
            <strong>Recommended Strategy:</strong> {simulation.executiveSummary?.recommendedAction}
          </div>
        </div>
      </div>

      {/* Before vs After State Matrix */}
      <div className="card">
        <div className="card-header">
          <h3 className="card-title">
            <Sliders size={18} color="#38BDF8" /> Before vs. Predicted After State
          </h3>
        </div>

        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "1.5rem" }}>
          {/* Before */}
          <div style={{ background: "rgba(30, 41, 59, 0.4)", padding: "1.25rem", borderRadius: "var(--radius-md)", border: "1px solid var(--border-subtle)" }}>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-muted)", marginBottom: "0.75rem" }}>
              Current Curriculum State
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: "0.5rem", fontSize: "0.85rem" }}>
              <div>Total Course Topics: <strong>{simulation.beforeState?.totalTopics}</strong></div>
              <div>Instructional Weeks: <strong>{simulation.beforeState?.totalWeeks} wks</strong></div>
              <div>Target Topic Hours: <strong>{simulation.beforeState?.targetTopicWeeks} wks</strong></div>
              <div>CLO Coverage: <strong>{simulation.beforeState?.cloCoverage}</strong></div>
              <div>Assessment Ratio: <strong>{simulation.beforeState?.theoryPracticalRatio}</strong></div>
            </div>
          </div>

          {/* After */}
          <div style={{ background: "rgba(239, 68, 68, 0.06)", padding: "1.25rem", borderRadius: "var(--radius-md)", border: "1px solid rgba(239, 68, 68, 0.25)" }}>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "#F87171", marginBottom: "0.75rem" }}>
              Predicted Curriculum State After Change
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: "0.5rem", fontSize: "0.85rem" }}>
              <div>Total Course Topics: <strong>{simulation.afterState?.totalTopics}</strong></div>
              <div>Instructional Weeks: <strong>{simulation.afterState?.totalWeeks} wks</strong></div>
              <div>Target Topic Hours: <strong>{simulation.afterState?.targetTopicWeeks} wks</strong></div>
              <div>CLO Coverage: <strong style={{ color: "#F87171" }}>{simulation.afterState?.cloCoverage}</strong></div>
              <div>Assessment Ratio: <strong>{simulation.afterState?.theoryPracticalRatio}</strong></div>
            </div>
          </div>
        </div>
      </div>

      {/* 7 Core Dimensions Tabbed Inspector */}
      <div className="card">
        {/* Navigation Tabs */}
        <div style={{ display: "flex", alignItems: "center", gap: "0.5rem", borderBottom: "1px solid var(--border-subtle)", paddingBottom: "0.75rem", overflowX: "auto" }}>
          {[
            { id: "clo", label: `CLO Impact (${simulation.cloImpact?.length || 0})` },
            { id: "prereq", label: `Prerequisite Risk (${simulation.prerequisiteImpact?.riskLevel || "LOW"})` },
            { id: "downstream", label: `Downstream Courses (${simulation.downstreamImpact?.length || 0})` },
            { id: "readiness", label: "Student Readiness Risk" },
            { id: "gaps", label: `Curriculum Gaps (${simulation.curriculumGaps?.length || 0})` },
            { id: "assessment", label: "Assessment Balance" },
            { id: "ripple", label: `Ripple Chain (${simulation.rippleEffect?.length || 0} nodes)` }
          ].map(tab => (
            <button 
              key={tab.id}
              className={`btn btn-sm ${activeTab === tab.id ? "btn-primary" : "btn-secondary"}`}
              onClick={() => setActiveTab(tab.id)}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {/* Tab 1: CLO Impact */}
        {activeTab === "clo" && (
          <div style={{ marginTop: "1.5rem", display: "flex", flexDirection: "column", gap: "1rem" }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
              <div>
                <h4 style={{ fontSize: "1.1rem" }}>Course Learning Outcomes (CLOs) Attainment</h4>
                <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)" }}>
                  Measures instructional time and assessment coverage reduction per CLO.
                </p>
              </div>
              {simulation.evidenceItems && simulation.evidenceItems.length > 0 && (
                <button 
                  className="btn btn-secondary btn-sm"
                  onClick={() => onOpenEvidence(simulation.evidenceItems[0])}
                >
                  <HelpCircle size={14} /> Inspect "Why?" Evidence
                </button>
              )}
            </div>

            {simulation.cloImpact?.map((clo, idx) => (
              <div 
                key={idx}
                style={{
                  background: "rgba(30, 41, 59, 0.4)",
                  border: `1px solid ${clo.delta < 0 ? "rgba(239, 68, 68, 0.3)" : "var(--border-subtle)"}`,
                  borderRadius: "var(--radius-md)",
                  padding: "1rem 1.25rem"
                }}
              >
                <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "0.5rem" }}>
                  <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
                    <strong>{clo.cloId}</strong>
                    <span className="badge badge-blue">Bloom: {clo.bloomLevel}</span>
                    {clo.severity === "HIGH" && <span className="badge badge-high">Severe Drop</span>}
                  </div>
                  <div style={{ fontSize: "0.85rem", fontWeight: 700, color: clo.delta < 0 ? "#F87171" : "#34D399" }}>
                    {clo.beforeCoverage}% ➔ {clo.afterCoverage}% ({clo.delta > 0 ? `+${clo.delta}%` : `${clo.delta}%`})
                  </div>
                </div>

                <div style={{ fontSize: "0.8rem", color: "var(--text-secondary)", marginBottom: "0.75rem" }}>
                  {clo.description}
                </div>

                {/* Progress Bar Before vs After */}
                <div style={{ width: "100%", height: "8px", background: "rgba(255, 255, 255, 0.1)", borderRadius: "4px", overflow: "hidden", position: "relative" }}>
                  <div style={{ position: "absolute", left: 0, top: 0, height: "100%", width: `${clo.beforeCoverage}%`, background: "rgba(56, 189, 248, 0.3)" }} />
                  <div style={{ position: "absolute", left: 0, top: 0, height: "100%", width: `${clo.afterCoverage}%`, background: clo.delta < 0 ? "#EF4444" : "#10B981" }} />
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Tab 2: Prerequisite Risk */}
        {activeTab === "prereq" && (
          <div style={{ marginTop: "1.5rem", display: "flex", flexDirection: "column", gap: "1rem" }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
              <div>
                <h4 style={{ fontSize: "1.1rem" }}>Prerequisite Knowledge Chain Analysis</h4>
                <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)" }}>
                  Evaluates broken foundational readiness for directly dependent courses.
                </p>
              </div>
              {simulation.evidenceItems && simulation.evidenceItems.length > 0 && (
                <button 
                  className="btn btn-secondary btn-sm"
                  onClick={() => onOpenEvidence(simulation.evidenceItems[0])}
                >
                  <HelpCircle size={14} /> Inspect "Why?" Evidence
                </button>
              )}
            </div>

            <div 
              style={{
                padding: "1.25rem",
                borderRadius: "var(--radius-md)",
                background: simulation.prerequisiteImpact?.riskLevel === "HIGH" ? "rgba(239, 68, 68, 0.08)" : "rgba(30, 41, 59, 0.4)",
                border: `1px solid ${simulation.prerequisiteImpact?.riskLevel === "HIGH" ? "rgba(239, 68, 68, 0.3)" : "var(--border-subtle)"}`
              }}
            >
              <div style={{ display: "flex", alignItems: "center", gap: "0.5rem", marginBottom: "0.5rem" }}>
                <span className={`badge ${simulation.prerequisiteImpact?.riskLevel === "HIGH" ? "badge-high" : "badge-low"}`}>
                  Prerequisite Risk: {simulation.prerequisiteImpact?.riskLevel} ({simulation.prerequisiteImpact?.score}/100)
                </span>
                <span style={{ fontSize: "0.85rem", color: "var(--text-secondary)" }}>
                  {simulation.prerequisiteImpact?.brokenDependenciesCount} broken dependencies
                </span>
              </div>
              <p style={{ fontSize: "0.9rem", color: "var(--text-primary)", lineHeight: 1.5, marginBottom: "1rem" }}>
                {simulation.prerequisiteImpact?.summary}
              </p>

              {simulation.prerequisiteImpact?.brokenTopics?.length > 0 && (
                <div>
                  <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-muted)", marginBottom: "0.5rem" }}>
                    Downstream Topics Left Without Required Foundations:
                  </div>
                  <div style={{ display: "flex", flexWrap: "wrap", gap: "0.5rem" }}>
                    {simulation.prerequisiteImpact.brokenTopics.map((topic, idx) => (
                      <span key={idx} className="badge badge-high" style={{ fontSize: "0.8rem", textTransform: "none" }}>
                        ⚠️ {topic}
                      </span>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        )}

        {/* Tab 3: Downstream Courses */}
        {activeTab === "downstream" && (
          <div style={{ marginTop: "1.5rem", display: "flex", flexDirection: "column", gap: "1rem" }}>
            <h4 style={{ fontSize: "1.1rem" }}>Transitive Downstream Cascade</h4>
            <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)" }}>
              Courses affected through the multi-hop prerequisite dependency graph.
            </p>

            <div style={{ display: "flex", flexDirection: "column", gap: "0.75rem" }}>
              {simulation.downstreamImpact?.map((dc, idx) => (
                <div 
                  key={idx}
                  style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    padding: "1rem 1.25rem",
                    background: "rgba(30, 41, 59, 0.4)",
                    border: "1px solid var(--border-subtle)",
                    borderRadius: "var(--radius-md)"
                  }}
                >
                  <div>
                    <div style={{ display: "flex", alignItems: "center", gap: "0.5rem", marginBottom: "4px" }}>
                      <strong>{dc.courseCode}</strong>
                      <span>— {dc.courseName}</span>
                      <span className={`badge ${dc.riskLevel === "HIGH" ? "badge-high" : dc.riskLevel === "MEDIUM" ? "badge-medium" : "badge-low"}`}>
                        {dc.riskLevel} (Distance: {dc.distance})
                      </span>
                    </div>
                    <div style={{ fontSize: "0.8rem", color: "var(--text-secondary)" }}>
                      {dc.reason}
                    </div>
                  </div>
                  <div style={{ textAlign: "right" }}>
                    <div style={{ fontSize: "1.2rem", fontWeight: 800, color: dc.riskLevel === "HIGH" ? "#F87171" : "#FBBF24" }}>
                      {dc.impactScore}
                    </div>
                    <div style={{ fontSize: "0.65rem", color: "var(--text-muted)", textTransform: "uppercase" }}>Impact Score</div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Tab 4: Student Readiness Risk */}
        {activeTab === "readiness" && (
          <div style={{ marginTop: "1.5rem", display: "flex", flexDirection: "column", gap: "1rem" }}>
            <h4 style={{ fontSize: "1.1rem" }}>7th Dimension: Student Readiness Risk</h4>
            <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)" }}>
              Predicts cohort academic friction when transitioning to advanced semesters.
            </p>

            <div 
              style={{
                padding: "1.5rem",
                borderRadius: "var(--radius-md)",
                background: "rgba(245, 158, 11, 0.08)",
                border: "1px solid rgba(245, 158, 11, 0.3)"
              }}
            >
              <div style={{ display: "flex", alignItems: "center", gap: "0.5rem", marginBottom: "0.75rem" }}>
                <span className="badge badge-medium">
                  Readiness Friction: {simulation.studentReadiness?.riskLevel} ({simulation.studentReadiness?.score}/100)
                </span>
                <span style={{ fontSize: "0.85rem", color: "var(--text-secondary)" }}>
                  Target: {simulation.studentReadiness?.targetCohort}
                </span>
              </div>
              <p style={{ fontSize: "0.9rem", color: "var(--text-primary)", lineHeight: 1.6 }}>
                {simulation.studentReadiness?.frictionPoint}
              </p>
            </div>
          </div>
        )}

        {/* Tab 5: Curriculum Gaps */}
        {activeTab === "gaps" && (
          <div style={{ marginTop: "1.5rem", display: "flex", flexDirection: "column", gap: "1rem" }}>
            <h4 style={{ fontSize: "1.1rem" }}>Curriculum Knowledge Gap Detection</h4>
            <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)" }}>
              Identifies foundational competencies left untaught across the 4-year degree program.
            </p>

            {simulation.curriculumGaps && simulation.curriculumGaps.length > 0 ? (
              simulation.curriculumGaps.map((gap, idx) => (
                <div 
                  key={idx}
                  style={{
                    padding: "1.25rem",
                    borderRadius: "var(--radius-md)",
                    background: "rgba(239, 68, 68, 0.08)",
                    border: "1px solid rgba(239, 68, 68, 0.3)"
                  }}
                >
                  <div style={{ display: "flex", alignItems: "center", gap: "0.5rem", marginBottom: "0.5rem" }}>
                    <span className="badge badge-high">{gap.severity} GAP</span>
                    <strong style={{ color: "#F87171" }}>{gap.concept}</strong>
                  </div>
                  <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "0.75rem" }}>
                    {gap.description}
                  </p>
                  <div style={{ fontSize: "0.8rem", color: "var(--accent-blue)" }}>
                    <strong>Remedy:</strong> {gap.suggestedRemedy}
                  </div>
                </div>
              ))
            ) : (
              <div style={{ padding: "1.5rem", textAlign: "center", color: "#34D399" }}>
                ✓ No critical knowledge gaps introduced by this change.
              </div>
            )}
          </div>
        )}

        {/* Tab 6: Assessment Balance */}
        {activeTab === "assessment" && (
          <div style={{ marginTop: "1.5rem", display: "flex", flexDirection: "column", gap: "1rem" }}>
            <h4 style={{ fontSize: "1.1rem" }}>Assessment Balance &amp; Distribution</h4>
            <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)" }}>
              Monitors theory vs practical laboratory balance.
            </p>

            <div 
              style={{
                padding: "1.25rem",
                borderRadius: "var(--radius-md)",
                background: "rgba(30, 41, 59, 0.4)",
                border: "1px solid var(--border-subtle)"
              }}
            >
              <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "0.5rem", fontSize: "0.9rem" }}>
                <span>Current: <strong>{simulation.assessmentImpact?.currentTheory}% Theory / {simulation.assessmentImpact?.currentPractical}% Practical</strong></span>
                <span>Predicted: <strong style={{ color: "#FBBF24" }}>{simulation.assessmentImpact?.predictedTheory}% Theory / {simulation.assessmentImpact?.predictedPractical}% Practical</strong></span>
              </div>
              <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)" }}>
                {simulation.assessmentImpact?.explanation}
              </p>
            </div>
          </div>
        )}

        {/* Tab 7: Ripple Chain */}
        {activeTab === "ripple" && (
          <div style={{ marginTop: "1.5rem", display: "flex", flexDirection: "column", gap: "1rem" }}>
            <h4 style={{ fontSize: "1.1rem" }}>Curriculum Ripple Effect Sequence</h4>
            <div className="ripple-flow">
              {simulation.rippleEffect?.map((node, idx) => (
                <React.Fragment key={idx}>
                  <div className={`ripple-node ${node.color}`}>
                    <div style={{ fontSize: "0.7rem", fontWeight: 700, color: "var(--accent-blue)", textTransform: "uppercase" }}>
                      {node.role}
                    </div>
                    <div style={{ fontWeight: 700, fontSize: "0.9rem", color: "var(--text-primary)", marginTop: "2px" }}>
                      {node.name}
                    </div>
                    <div style={{ fontSize: "0.75rem", color: "var(--text-secondary)", margin: "4px 0" }}>
                      {node.details}
                    </div>
                    <span className={`badge badge-${node.level === "HIGH" ? "high" : node.level === "MEDIUM" ? "medium" : "low"}`} style={{ fontSize: "0.65rem" }}>
                      {node.badge}
                    </span>
                  </div>
                  {idx < simulation.rippleEffect.length - 1 && (
                    <div className="ripple-arrow">➔</div>
                  )}
                </React.Fragment>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Faculty Decision & Control Section */}
      <div 
        className="card"
        style={{
          border: "1px solid rgba(56, 189, 248, 0.4)",
          background: "linear-gradient(180deg, rgba(15, 23, 42, 0.95), rgba(8, 13, 26, 0.95))"
        }}
      >
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "1rem" }}>
          <div>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "var(--accent-blue)" }}>
              Faculty Authority
            </div>
            <h3 style={{ fontSize: "1.25rem" }}>Record Faculty Academic Decision</h3>
          </div>
          <span 
            className="badge"
            style={{
              background: facultyDecision === "REJECT_PROPOSAL" ? "rgba(239, 68, 68, 0.2)" : facultyDecision === "ACCEPT_PROPOSAL" ? "rgba(16, 185, 129, 0.2)" : "rgba(245, 158, 11, 0.2)",
              color: facultyDecision === "REJECT_PROPOSAL" ? "#F87171" : facultyDecision === "ACCEPT_PROPOSAL" ? "#34D399" : "#FBBF24"
            }}
          >
            Status: {facultyDecision.replace(/_/g, " ")}
          </span>
        </div>

        <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "1.25rem" }}>
          The AI simulator provides analytical evidence and risk warnings. The final academic decision is recorded by the authorized faculty member.
        </p>

        <div style={{ display: "flex", gap: "0.75rem", flexWrap: "wrap", marginBottom: "1.25rem" }}>
          {[
            { id: "REJECT_PROPOSAL", label: "Reject Proposal (High Risk)", color: "#EF4444" },
            { id: "MODIFY_PROPOSAL", label: "Adopt Plan B/C (Tuned)", color: "#F59E0B" },
            { id: "SEND_FOR_COMMITTEE_REVIEW", label: "Send to Curriculum Committee", color: "#38BDF8" },
            { id: "ACCEPT_PROPOSAL", label: "Accept Proposal Anyway", color: "#10B981" }
          ].map(action => (
            <button 
              key={action.id}
              className={`btn btn-sm ${facultyDecision === action.id ? "btn-primary" : "btn-secondary"}`}
              style={facultyDecision === action.id ? { borderColor: action.color } : {}}
              onClick={() => setFacultyDecision(action.id)}
            >
              {action.label}
            </button>
          ))}
        </div>

        <div style={{ marginBottom: "1.25rem" }}>
          <label style={{ display: "block", fontSize: "0.8rem", color: "var(--text-secondary)", marginBottom: "0.4rem" }}>
            Faculty Committee Notes &amp; Rationale:
          </label>
          <textarea 
            rows="2"
            value={facultyNotes}
            onChange={(e) => setFacultyNotes(e.target.value)}
            placeholder="Document faculty decision for the departmental academic audit trail..."
            style={{
              width: "100%",
              padding: "0.75rem",
              background: "var(--bg-tertiary)",
              border: "1px solid var(--border-strong)",
              borderRadius: "var(--radius-sm)",
              color: "var(--text-primary)",
              fontSize: "0.85rem"
            }}
          />
        </div>

        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div style={{ fontSize: "0.8rem", color: saveSuccess ? "#34D399" : "var(--text-muted)" }}>
            {saveSuccess ? "✓ Decision saved to persistent simulation history." : "Changes are stored locally in the registry."}
          </div>
          <button className="btn btn-primary btn-sm" onClick={handleDecisionSave}>
            <CheckCircle2 size={16} /> Save Decision to History
          </button>
        </div>
      </div>

      {/* "How is this calculated?" Formula Modal */}
      {showFormulaModal && (
        <div className="modal-overlay" onClick={() => setShowFormulaModal(false)}>
          <div className="modal-content" onClick={e => e.stopPropagation()}>
            <h3 style={{ fontSize: "1.3rem", marginBottom: "0.5rem" }}>
              Explainable Scoring Model: How is the {simulation.overallScore}/100 Derived?
            </h3>
            <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "1.25rem" }}>
              Acaddie does NOT generate arbitrary numbers. The score is mathematically calculated from a weighted multi-factor regression:
            </p>

            <div 
              style={{
                padding: "1rem",
                background: "rgba(56, 189, 248, 0.08)",
                border: "1px solid rgba(56, 189, 248, 0.3)",
                borderRadius: "var(--radius-md)",
                fontFamily: "monospace",
                fontSize: "0.85rem",
                color: "#93C5FD",
                marginBottom: "1.25rem"
              }}
            >
              Overall = (CLO × 0.30) + (Prereq × 0.25) + (Downstream × 0.20) + (Gap × 0.10) + (Assessment × 0.10) + (Overlap × 0.05)
            </div>

            <table className="comparison-table" style={{ marginBottom: "1.5rem" }}>
              <thead>
                <tr>
                  <th>Dimension</th>
                  <th>Sub-Score</th>
                  <th>Weight</th>
                  <th>Weighted Contribution</th>
                </tr>
              </thead>
              <tbody>
                {simulation.breakdown?.map((b, idx) => (
                  <tr key={idx}>
                    <td><strong>{b.name}</strong></td>
                    <td>{b.score} / 100</td>
                    <td>{b.weight}</td>
                    <td style={{ color: "var(--accent-blue)", fontWeight: 700 }}>+{b.weightedContribution}</td>
                  </tr>
                ))}
              </tbody>
            </table>

            <div style={{ textAlign: "right" }}>
              <button className="btn btn-secondary btn-sm" onClick={() => setShowFormulaModal(false)}>
                Close Window
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
