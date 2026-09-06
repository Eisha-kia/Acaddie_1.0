import React, { useState } from "react";
import { History, Search, FileText, ArrowRight, CheckCircle2, ShieldAlert } from "lucide-react";

export default function SimulationHistory({ history, onReopenSimulation }) {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterRisk, setFilterRisk] = useState("ALL");

  const filteredHistory = (history || []).filter(item => {
    const matchesSearch = 
      item.course?.code?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.course?.name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.action?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.targetTopic?.name?.toLowerCase().includes(searchTerm.toLowerCase());

    const matchesRisk = filterRisk === "ALL" || item.riskLevel === filterRisk;
    return matchesSearch && matchesRisk;
  });

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "2rem" }}>
      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", flexWrap: "wrap", gap: "1rem" }}>
        <div>
          <span className="badge badge-blue">Audit Trail</span>
          <h1 style={{ fontSize: "2rem", marginTop: "4px" }}>Simulation History &amp; Faculty Decisions</h1>
          <p style={{ fontSize: "0.95rem", color: "var(--text-secondary)" }}>
            Review past academic impact analyses, modeled risks, and recorded faculty committee determinations.
          </p>
        </div>

        {/* Filters */}
        <div style={{ display: "flex", alignItems: "center", gap: "0.75rem", flexWrap: "wrap" }}>
          <div style={{ position: "relative" }}>
            <Search size={16} style={{ position: "absolute", left: "10px", top: "10px", color: "var(--text-muted)" }} />
            <input 
              type="text"
              placeholder="Search course or topic..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              style={{
                padding: "0.45rem 0.85rem 0.45rem 2.2rem",
                background: "var(--bg-tertiary)",
                border: "1px solid var(--border-subtle)",
                borderRadius: "var(--radius-sm)",
                color: "var(--text-primary)",
                fontSize: "0.85rem"
              }}
            />
          </div>

          <select 
            value={filterRisk}
            onChange={(e) => setFilterRisk(e.target.value)}
            style={{
              padding: "0.45rem 0.85rem",
              background: "var(--bg-tertiary)",
              border: "1px solid var(--border-subtle)",
              borderRadius: "var(--radius-sm)",
              color: "var(--text-primary)",
              fontSize: "0.85rem"
            }}
          >
            <option value="ALL">All Risk Levels</option>
            <option value="HIGH">High Risk</option>
            <option value="MEDIUM">Medium Risk</option>
            <option value="LOW">Low Risk</option>
          </select>
        </div>
      </div>

      {/* History Table */}
      <div className="card">
        <div style={{ overflowX: "auto" }}>
          <table className="comparison-table">
            <thead>
              <tr>
                <th>Date &amp; ID</th>
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
              {filteredHistory.length > 0 ? (
                filteredHistory.map((item, idx) => (
                  <tr key={idx}>
                    <td>
                      <div style={{ fontSize: "0.8rem", color: "var(--text-primary)", fontWeight: 500 }}>
                        {new Date(item.timestamp).toLocaleDateString()}
                      </div>
                      <div style={{ fontSize: "0.7rem", color: "var(--text-muted)", fontFamily: "monospace" }}>
                        {item.simulationId}
                      </div>
                    </td>

                    <td>
                      <strong style={{ color: "var(--text-primary)" }}>{item.course?.code}</strong>
                      <div style={{ fontSize: "0.75rem", color: "var(--text-secondary)" }}>
                        {item.course?.name}
                      </div>
                    </td>

                    <td>
                      <div style={{ fontWeight: 600, fontSize: "0.85rem" }}>
                        {item.action.replace(/_/g, " ")}
                      </div>
                      <div style={{ fontSize: "0.75rem", color: "var(--text-muted)" }}>
                        Target: {item.targetTopic?.name || "Assessment Structure"}
                      </div>
                    </td>

                    <td>
                      <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
                        <span style={{ fontWeight: 800, fontSize: "1rem" }}>{item.overallScore}</span>
                        <span style={{ fontSize: "0.75rem", color: "var(--text-muted)" }}>/ 100</span>
                      </div>
                    </td>

                    <td>
                      <span className={`badge ${item.riskLevel === "HIGH" ? "badge-high" : item.riskLevel === "MEDIUM" ? "badge-medium" : "badge-low"}`}>
                        {item.riskLevel}
                      </span>
                    </td>

                    <td style={{ color: "var(--text-secondary)", fontSize: "0.85rem" }}>
                      {item.confidence}%
                    </td>

                    <td>
                      <div 
                        style={{
                          fontSize: "0.75rem",
                          fontWeight: 700,
                          color: item.facultyDecision === "REJECT_PROPOSAL" ? "#F87171" : item.facultyDecision === "ACCEPT_PROPOSAL" ? "#34D399" : "#FBBF24"
                        }}
                      >
                        {item.facultyDecision.replace(/_/g, " ")}
                      </div>
                      {item.facultyNotes && (
                        <div style={{ fontSize: "0.7rem", color: "var(--text-muted)", maxWidth: "200px", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
                          {item.facultyNotes}
                        </div>
                      )}
                    </td>

                    <td>
                      <button 
                        className="btn btn-secondary btn-sm"
                        onClick={() => onReopenSimulation(item.simulationId)}
                      >
                        <FileText size={14} /> View
                      </button>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan="8" style={{ textAlign: "center", padding: "2.5rem", color: "var(--text-muted)" }}>
                    No simulation records match your filter criteria.
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
