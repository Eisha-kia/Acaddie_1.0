import React from "react";
import { GitCompare, CheckCircle2, AlertTriangle, ShieldCheck, ArrowRight, HelpCircle } from "lucide-react";

export default function WhatIfComparison({ simulation, onExportReport, onViewOnMap }) {
  if (!simulation || !simulation.alternatives) {
    return (
      <div className="card" style={{ textAlign: "center", padding: "3rem" }}>
        <h3>No active simulation to compare.</h3>
        <p style={{ color: "var(--text-secondary)", marginTop: "0.5rem" }}>
          Run a simulation from the studio or select a demo scenario to view side-by-side What-If comparison plans.
        </p>
      </div>
    );
  }

  const plans = simulation.alternatives;

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "2rem" }}>
      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", flexWrap: "wrap", gap: "1rem" }}>
        <div>
          <span className="badge badge-blue">What-If Multi-Plan Decision Matrix</span>
          <h1 style={{ fontSize: "2rem", marginTop: "4px" }}>Compare Academic Decision Alternatives</h1>
          <p style={{ fontSize: "0.95rem", color: "var(--text-secondary)" }}>
            Evaluate trade-offs between the proposed action and safer synthesized alternatives for {simulation.course?.code}.
          </p>
        </div>

        <div style={{ display: "flex", alignItems: "center", gap: "0.75rem" }}>
          <button className="btn btn-secondary" onClick={onViewOnMap}>
            View Ripple on Map
          </button>
          <button className="btn btn-primary" onClick={onExportReport}>
            Export Comparison Report
          </button>
        </div>
      </div>

      {/* Plan Cards Grid */}
      <div 
        style={{
          display: "grid",
          gridTemplateColumns: `repeat(${plans.length}, 1fr)`,
          gap: "1.5rem"
        }}
      >
        {plans.map((plan, idx) => {
          const isSafest = plan.isSafest;
          return (
            <div 
              key={idx}
              className="card"
              style={{
                border: isSafest ? "2px solid #10B981" : "1px solid var(--border-subtle)",
                background: isSafest ? "linear-gradient(180deg, rgba(16, 185, 129, 0.08), var(--bg-card))" : "var(--bg-card)",
                display: "flex",
                flexDirection: "column",
                justifyContent: "space-between",
                position: "relative"
              }}
            >
              {isSafest && (
                <div 
                  style={{
                    position: "absolute",
                    top: "-12px",
                    right: "20px",
                    background: "#10B981",
                    color: "#064E3B",
                    padding: "2px 10px",
                    borderRadius: "var(--radius-full)",
                    fontSize: "0.7rem",
                    fontWeight: 800,
                    textTransform: "uppercase"
                  }}
                >
                  ✓ Lowest Modeled Impact
                </div>
              )}

              <div>
                <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "0.5rem" }}>
                  <span className={`badge ${plan.riskLevel === "HIGH" ? "badge-high" : plan.riskLevel === "MEDIUM" ? "badge-medium" : "badge-low"}`}>
                    {plan.riskLevel} RISK ({plan.overallImpact}/100)
                  </span>
                  <span style={{ fontSize: "0.75rem", color: "var(--text-muted)" }}>{plan.tag}</span>
                </div>

                <h3 style={{ fontSize: "1.2rem", marginBottom: "0.5rem" }}>{plan.name}</h3>
                <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", lineHeight: 1.5, marginBottom: "1.25rem" }}>
                  {plan.description}
                </p>

                {/* Pros */}
                <div style={{ marginBottom: "0.75rem" }}>
                  <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "#34D399", marginBottom: "4px" }}>
                    Curricular Advantages:
                  </div>
                  {plan.pros.map((pro, pIdx) => (
                    <div key={pIdx} style={{ display: "flex", alignItems: "flex-start", gap: "0.4rem", fontSize: "0.8rem", color: "var(--text-primary)", marginBottom: "2px" }}>
                      <span style={{ color: "#10B981" }}>+</span>
                      <span>{pro}</span>
                    </div>
                  ))}
                </div>

                {/* Cons */}
                <div style={{ marginBottom: "1.25rem" }}>
                  <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "#F87171", marginBottom: "4px" }}>
                    Trade-offs &amp; Friction:
                  </div>
                  {plan.cons.map((con, cIdx) => (
                    <div key={cIdx} style={{ display: "flex", alignItems: "flex-start", gap: "0.4rem", fontSize: "0.8rem", color: "var(--text-secondary)", marginBottom: "2px" }}>
                      <span style={{ color: "#EF4444" }}>-</span>
                      <span>{con}</span>
                    </div>
                  ))}
                </div>
              </div>

              <div 
                style={{
                  padding: "0.75rem",
                  borderRadius: "var(--radius-sm)",
                  background: isSafest ? "rgba(16, 185, 129, 0.1)" : "rgba(30, 41, 59, 0.5)",
                  border: `1px solid ${isSafest ? "rgba(16, 185, 129, 0.25)" : "var(--border-subtle)"}`,
                  fontSize: "0.8rem",
                  color: isSafest ? "#A7F3D0" : "var(--text-muted)",
                  lineHeight: 1.4
                }}
              >
                <strong>Academic Rationale:</strong> {plan.recommendationRationale}
              </div>
            </div>
          );
        })}
      </div>

      {/* Side-by-Side Dimension Comparison Table */}
      <div className="card">
        <div className="card-header">
          <h3 className="card-title">
            <GitCompare size={18} color="#38BDF8" /> Side-by-Side Impact Matrix
          </h3>
        </div>

        <div style={{ overflowX: "auto" }}>
          <table className="comparison-table">
            <thead>
              <tr>
                <th style={{ width: "24%" }}>Curricular Dimension</th>
                {plans.map((p, idx) => (
                  <th key={idx} className={p.isSafest ? "comparison-plan-col highlight-safe" : ""} style={{ width: `${76 / plans.length}%` }}>
                    {p.name}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><strong>Overall Modeled Impact Score</strong></td>
                {plans.map((p, idx) => (
                  <td key={idx} className={p.isSafest ? "comparison-plan-col highlight-safe" : ""}>
                    <strong style={{ fontSize: "1.1rem", color: p.riskLevel === "HIGH" ? "#F87171" : p.riskLevel === "MEDIUM" ? "#FBBF24" : "#34D399" }}>
                      {p.overallImpact} / 100
                    </strong> ({p.riskLevel})
                  </td>
                ))}
              </tr>

              <tr>
                <td><strong>CLO Attainment Impact</strong></td>
                {plans.map((p, idx) => (
                  <td key={idx} className={p.isSafest ? "comparison-plan-col highlight-safe" : ""}>
                    {p.cloImpact}
                  </td>
                ))}
              </tr>

              <tr>
                <td><strong>Prerequisite Knowledge Risk</strong></td>
                {plans.map((p, idx) => (
                  <td key={idx} className={p.isSafest ? "comparison-plan-col highlight-safe" : ""}>
                    {p.prerequisiteRisk}
                  </td>
                ))}
              </tr>

              <tr>
                <td><strong>Downstream Course Cascade</strong></td>
                {plans.map((p, idx) => (
                  <td key={idx} className={p.isSafest ? "comparison-plan-col highlight-safe" : ""}>
                    {p.downstreamRisk}
                  </td>
                ))}
              </tr>

              <tr>
                <td><strong>Curriculum Knowledge Gap</strong></td>
                {plans.map((p, idx) => (
                  <td key={idx} className={p.isSafest ? "comparison-plan-col highlight-safe" : ""}>
                    {p.curriculumGap}
                  </td>
                ))}
              </tr>

              <tr>
                <td><strong>Assessment Imbalance Risk</strong></td>
                {plans.map((p, idx) => (
                  <td key={idx} className={p.isSafest ? "comparison-plan-col highlight-safe" : ""}>
                    {p.assessmentRisk}
                  </td>
                ))}
              </tr>

              <tr>
                <td><strong>Student Transition Readiness</strong></td>
                {plans.map((p, idx) => (
                  <td key={idx} className={p.isSafest ? "comparison-plan-col highlight-safe" : ""}>
                    {p.studentReadiness}
                  </td>
                ))}
              </tr>
            </tbody>
          </table>
        </div>

        <div style={{ marginTop: "1.25rem", padding: "0.75rem 1rem", background: "rgba(30, 41, 59, 0.5)", borderRadius: "var(--radius-sm)", fontSize: "0.8rem", color: "var(--text-muted)" }}>
          ℹ️ <strong>Academic Independence Notice:</strong> Acaddie models the statistical and structural ripple effects of each scenario. The curriculum committee and course instructor maintain full authority to select whichever plan aligns best with their pedagogical goals.
        </div>
      </div>
    </div>
  );
}
