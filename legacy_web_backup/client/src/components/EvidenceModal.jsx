import React from "react";
import { X, ShieldCheck, ArrowRight, BookOpen, AlertTriangle } from "lucide-react";

export default function EvidenceModal({ evidence, onClose }) {
  if (!evidence) return null;

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div 
        className="modal-content"
        onClick={e => e.stopPropagation()}
        style={{ maxWidth: "700px" }}
      >
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "1.25rem" }}>
          <div style={{ display: "flex", alignItems: "center", gap: "0.6rem" }}>
            <div 
              style={{
                width: "36px",
                height: "36px",
                borderRadius: "var(--radius-sm)",
                background: "rgba(56, 189, 248, 0.12)",
                color: "var(--accent-blue)",
                display: "flex",
                alignItems: "center",
                justifyContent: "center"
              }}
            >
              <ShieldCheck size={20} />
            </div>
            <div>
              <span style={{ fontSize: "0.7rem", fontWeight: 700, textTransform: "uppercase", color: "var(--accent-blue)" }}>
                The "Why?" Evidence Layer
              </span>
              <h3 style={{ fontSize: "1.2rem", lineHeight: 1.2 }}>{evidence.title}</h3>
            </div>
          </div>
          <button 
            onClick={onClose}
            style={{
              background: "transparent",
              border: "none",
              color: "var(--text-muted)",
              cursor: "pointer",
              padding: "4px"
            }}
          >
            <X size={20} />
          </button>
        </div>

        {/* Evidence Type Tag */}
        <div style={{ marginBottom: "1.25rem" }}>
          <span 
            className="badge"
            style={{
              background: "rgba(16, 185, 129, 0.12)",
              color: "#34D399",
              border: "1px solid rgba(16, 185, 129, 0.3)",
              fontSize: "0.75rem"
            }}
          >
            ✓ {evidence.evidenceType} (Not an AI Hallucination)
          </span>
        </div>

        {/* Summary */}
        <p style={{ fontSize: "0.9rem", color: "var(--text-secondary)", lineHeight: 1.6, marginBottom: "1.5rem" }}>
          {evidence.summary}
        </p>

        {/* Structural Graph Chain */}
        {evidence.graphChain && evidence.graphChain.length > 0 && (
          <div 
            style={{
              background: "rgba(15, 23, 42, 0.7)",
              border: "1px solid var(--border-subtle)",
              borderRadius: "var(--radius-md)",
              padding: "1.25rem",
              marginBottom: "1.5rem"
            }}
          >
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-muted)", marginBottom: "0.75rem" }}>
              Causal Graph Dependency Path
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: "0.5rem" }}>
              {evidence.graphChain.map((step, idx) => (
                <div key={idx} style={{ display: "flex", alignItems: "center", gap: "0.75rem", fontSize: "0.85rem" }}>
                  <div 
                    style={{
                      width: "22px",
                      height: "22px",
                      borderRadius: "50%",
                      background: "rgba(56, 189, 248, 0.15)",
                      color: "var(--accent-blue)",
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "center",
                      fontSize: "0.75rem",
                      fontWeight: 700
                    }}
                  >
                    {idx + 1}
                  </div>
                  <span style={{ color: "var(--text-primary)", fontFamily: "monospace", fontSize: "0.85rem" }}>
                    {step}
                  </span>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Specific Path Explanations */}
        {evidence.paths && evidence.paths.length > 0 && (
          <div style={{ display: "flex", flexDirection: "column", gap: "0.85rem", marginBottom: "1.5rem" }}>
            <div style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-muted)" }}>
              Syllabus Dependency Relations
            </div>
            {evidence.paths.map((p, idx) => (
              <div 
                key={idx}
                style={{
                  background: "rgba(30, 41, 59, 0.4)",
                  border: "1px solid var(--border-subtle)",
                  borderRadius: "var(--radius-sm)",
                  padding: "0.85rem",
                  fontSize: "0.85rem"
                }}
              >
                <div style={{ display: "flex", alignItems: "center", gap: "0.5rem", fontWeight: 600, color: "var(--text-primary)", marginBottom: "4px" }}>
                  <span>{p.fromCourse}</span>
                  <ArrowRight size={14} color="#38BDF8" />
                  <span>{p.toCourse}</span>
                </div>
                <div style={{ fontSize: "0.8rem", color: "var(--text-secondary)", lineHeight: 1.4 }}>
                  {p.academicReason}
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Accreditation Reference */}
        {evidence.academicStandardReference && (
          <div 
            style={{
              display: "flex",
              alignItems: "flex-start",
              gap: "0.6rem",
              padding: "0.85rem",
              borderRadius: "var(--radius-sm)",
              background: "rgba(245, 158, 11, 0.08)",
              border: "1px solid rgba(245, 158, 11, 0.25)",
              color: "#FBBF24",
              fontSize: "0.8rem",
              lineHeight: 1.4
            }}
          >
            <BookOpen size={16} style={{ flexShrink: 0, marginTop: "2px" }} />
            <div>
              <strong>Accreditation Reference:</strong> {evidence.academicStandardReference}
            </div>
          </div>
        )}

        <div style={{ marginTop: "1.75rem", textAlign: "right" }}>
          <button className="btn btn-secondary btn-sm" onClick={onClose}>
            Close Evidence Window
          </button>
        </div>
      </div>
    </div>
  );
}
