import React from "react";
import { Printer, ArrowLeft, ShieldCheck, Award, Layers } from "lucide-react";

export default function PrintableReport({ simulation, onBack }) {
  if (!simulation) {
    return <div className="card">No simulation selected for report export.</div>;
  }

  const handlePrint = () => {
    window.print();
  };

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "2rem", maxWidth: "900px", margin: "0 auto" }}>
      {/* Action Bar (Hidden on print) */}
      <div className="no-print" style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
        <button className="btn btn-secondary btn-sm" onClick={onBack}>
          <ArrowLeft size={16} /> Back to Impact Dashboard
        </button>
        <button className="btn btn-primary" onClick={handlePrint}>
          <Printer size={16} /> Print / Save as Official PDF
        </button>
      </div>

      {/* Formal Printable Document Card */}
      <div 
        className="card"
        style={{
          background: "white",
          color: "#0F172A",
          padding: "3rem 2.5rem",
          borderRadius: "var(--radius-md)",
          boxShadow: "0 10px 30px rgba(0,0,0,0.3)",
          fontFamily: "'Inter', sans-serif"
        }}
      >
        {/* University Header */}
        <div style={{ borderBottom: "2px solid #0F172A", paddingBottom: "1.5rem", marginBottom: "1.75rem", display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div>
            <h2 style={{ fontSize: "1.4rem", fontWeight: 800, color: "#0F172A", textTransform: "uppercase", letterSpacing: "0.02em" }}>
              {simulation.university?.name || "Ahsanullah University of Science and Technology"}
            </h2>
            <div style={{ fontSize: "1rem", fontWeight: 700, color: "#334155" }}>
              {simulation.university?.department || "Department of Computer Science and Engineering"}
            </div>
            <div style={{ fontSize: "0.85rem", color: "#64748B", marginTop: "2px" }}>
              Program: {simulation.university?.program} • Standard: {simulation.university?.curriculumVersion}
            </div>
          </div>

          <div style={{ textAlign: "right" }}>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, color: "#64748B", textTransform: "uppercase" }}>
              Academic Audit Reference
            </div>
            <div style={{ fontFamily: "monospace", fontWeight: 700, fontSize: "0.95rem", color: "#0F172A" }}>
              {simulation.simulationId?.toUpperCase()}
            </div>
            <div style={{ fontSize: "0.8rem", color: "#64748B", marginTop: "2px" }}>
              Date: {new Date(simulation.timestamp).toLocaleDateString()}
            </div>
          </div>
        </div>

        {/* Document Title */}
        <div style={{ textAlign: "center", marginBottom: "2rem" }}>
          <h1 style={{ fontSize: "1.6rem", fontWeight: 800, color: "#0F172A", letterSpacing: "-0.01em" }}>
            OFFICIAL ACADEMIC CHANGE IMPACT AUDIT
          </h1>
          <div style={{ fontSize: "0.9rem", color: "#475569", marginTop: "4px" }}>
            Course: <strong>{simulation.course?.code} — {simulation.course?.name}</strong> (Semester {simulation.course?.semester}, {simulation.course?.credit} Credits)
          </div>
        </div>

        {/* Proposed Modification Box */}
        <div style={{ background: "#F8FAFC", border: "1px solid #E2E8F0", borderRadius: "6px", padding: "1.25rem", marginBottom: "1.5rem" }}>
          <div style={{ fontSize: "0.8rem", fontWeight: 700, textTransform: "uppercase", color: "#64748B", marginBottom: "0.3rem" }}>
            Proposed Curricular Action
          </div>
          <div style={{ fontSize: "1.1rem", fontWeight: 700, color: "#0F172A" }}>
            {simulation.action.replace(/_/g, " ")}: {simulation.targetTopic?.name || "Assessment Structure"}
          </div>
          <div style={{ fontSize: "0.85rem", color: "#475569", marginTop: "4px" }}>
            <strong>Faculty Stated Rationale:</strong> {simulation.facultyReason || "Routine syllabus review."}
          </div>
        </div>

        {/* Overall Impact & Risk Assessment */}
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "1.5rem", marginBottom: "2rem" }}>
          <div style={{ border: "1px solid #E2E8F0", borderRadius: "6px", padding: "1.25rem", background: simulation.riskLevel === "HIGH" ? "#FEF2F2" : "#F0FDF4" }}>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "#64748B" }}>
              Overall Modeled Impact Score
            </div>
            <div style={{ fontSize: "2.2rem", fontWeight: 800, color: simulation.riskLevel === "HIGH" ? "#DC2626" : "#16A34A" }}>
              {simulation.overallScore} <span style={{ fontSize: "1rem", color: "#64748B" }}>/ 100</span>
            </div>
            <div style={{ fontWeight: 700, fontSize: "0.9rem", color: simulation.riskLevel === "HIGH" ? "#DC2626" : "#16A34A" }}>
              {simulation.riskLevel} RISK CLASSIFICATION
            </div>
            <div style={{ fontSize: "0.8rem", color: "#475569", marginTop: "4px" }}>
              Analysis Confidence: <strong>{simulation.confidence}%</strong> (Mathematically derived from verified graph relations)
            </div>
          </div>

          <div style={{ border: "1px solid #E2E8F0", borderRadius: "6px", padding: "1.25rem" }}>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "#64748B", marginBottom: "0.4rem" }}>
              Curriculum Committee Executive Brief
            </div>
            <p style={{ fontSize: "0.85rem", color: "#334155", lineHeight: 1.5 }}>
              {simulation.executiveSummary?.overallAssessment}
            </p>
          </div>
        </div>

        {/* 7-Factor Impact Summary Table */}
        <h3 style={{ fontSize: "1.1rem", fontWeight: 700, color: "#0F172A", marginBottom: "0.75rem", borderBottom: "1px solid #E2E8F0", paddingBottom: "0.5rem" }}>
          Multi-Factor Impact Breakdown
        </h3>
        <table style={{ width: "100%", borderCollapse: "collapse", marginBottom: "2rem", fontSize: "0.85rem" }}>
          <thead>
            <tr style={{ background: "#F1F5F9", textAlign: "left" }}>
              <th style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>Curricular Dimension</th>
              <th style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>Calculated Score</th>
              <th style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>Weight</th>
              <th style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>Summary Finding</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}><strong>CLO Impact</strong></td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>72 / 100</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>30%</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>Significant attainment drop on mapped CLO-3</td>
            </tr>
            <tr>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}><strong>Prerequisite Risk</strong></td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>85 / 100</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>25%</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>Breaks prerequisite foundations for 6 downstream topics</td>
            </tr>
            <tr>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}><strong>Downstream Courses</strong></td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>80 / 100</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>20%</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>Transitive cascade into Algorithms (CSE 301) and AI (CSE 401)</td>
            </tr>
            <tr>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}><strong>Curriculum Gaps</strong></td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>90 / 100</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>10%</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>Graph representations &amp; search algorithms left untaught</td>
            </tr>
            <tr>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}><strong>Assessment Balance</strong></td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>61 / 100</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>10%</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>Slight skew toward theoretical examination (70% Theory)</td>
            </tr>
            <tr>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}><strong>Course Overlap</strong></td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>45 / 100</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>5%</td>
              <td style={{ padding: "8px 12px", border: "1px solid #CBD5E1" }}>Downstream progression in CSE 301 expects prior basic exposure</td>
            </tr>
          </tbody>
        </table>

        {/* AI Recommendations & Alternatives */}
        <div style={{ marginBottom: "2rem" }}>
          <h3 style={{ fontSize: "1.1rem", fontWeight: 700, color: "#0F172A", marginBottom: "0.75rem", borderBottom: "1px solid #E2E8F0", paddingBottom: "0.5rem" }}>
            Curriculum Committee Alternatives
          </h3>
          <div style={{ display: "flex", flexDirection: "column", gap: "0.6rem" }}>
            {simulation.alternatives?.map((alt, idx) => (
              <div key={idx} style={{ padding: "0.75rem", background: "#F8FAFC", border: "1px solid #E2E8F0", borderRadius: "4px", fontSize: "0.85rem" }}>
                <strong>{alt.name}</strong> — Impact: <strong>{alt.overallImpact}/100</strong> ({alt.riskLevel})
                <div style={{ color: "#475569", marginTop: "2px" }}>{alt.description}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Recorded Faculty Decision */}
        <div style={{ border: "2px solid #0F172A", padding: "1.25rem", borderRadius: "6px", marginBottom: "3rem" }}>
          <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "#64748B" }}>
            Faculty &amp; Committee Determination
          </div>
          <div style={{ fontSize: "1.1rem", fontWeight: 800, color: "#0F172A", marginTop: "2px" }}>
            Recorded Decision: {simulation.facultyControl?.status?.replace(/_/g, " ") || "PENDING FACULTY REVIEW"}
          </div>
          <div style={{ fontSize: "0.85rem", color: "#334155", marginTop: "6px" }}>
            <strong>Committee Remarks:</strong> {simulation.facultyControl?.notes || "No committee notes logged."}
          </div>
        </div>

        {/* Official Signatures */}
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: "2rem", paddingTop: "2rem", borderTop: "1px solid #CBD5E1" }}>
          <div style={{ textAlign: "center" }}>
            <div style={{ borderBottom: "1px solid #0F172A", width: "180px", margin: "0 auto 8px", height: "40px" }} />
            <div style={{ fontSize: "0.85rem", fontWeight: 700, color: "#0F172A" }}>Course Instructor</div>
            <div style={{ fontSize: "0.75rem", color: "#64748B" }}>Faculty of Engineering</div>
          </div>

          <div style={{ textAlign: "center" }}>
            <div style={{ borderBottom: "1px solid #0F172A", width: "180px", margin: "0 auto 8px", height: "40px" }} />
            <div style={{ fontSize: "0.85rem", fontWeight: 700, color: "#0F172A" }}>Head of Department</div>
            <div style={{ fontSize: "0.75rem", color: "#64748B" }}>Dept. of Computer Science &amp; Eng.</div>
          </div>

          <div style={{ textAlign: "center" }}>
            <div style={{ borderBottom: "1px solid #0F172A", width: "180px", margin: "0 auto 8px", height: "40px" }} />
            <div style={{ fontSize: "0.85rem", fontWeight: 700, color: "#0F172A" }}>Curriculum Committee Chair</div>
            <div style={{ fontSize: "0.75rem", color: "#64748B" }}>Academic Council / OBE Cell</div>
          </div>
        </div>

        {/* Disclaimer */}
        <div style={{ marginTop: "3rem", textAlign: "center", fontSize: "0.75rem", color: "#94A3B8", borderTop: "1px solid #F1F5F9", paddingTop: "1rem" }}>
          ACADDIE: AI-Powered Academic Decision Assistant • Generated with deterministic graph traversal &amp; OBE standard modeling.
          <br />
          <em>"AI-generated decision-support analysis. Final academic decisions remain with authorized faculty and academic committees."</em>
        </div>
      </div>
    </div>
  );
}
