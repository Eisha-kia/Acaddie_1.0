import React, { useState, useEffect } from "react";
import { CheckCircle2, Loader2, Sparkles, Layers } from "lucide-react";

export default function ProcessingAnimation({ onComplete }) {
  const steps = [
    "Analyzing academic structure & syllabus...",
    "Tracing topic-to-topic dependency chains...",
    "Checking Course Learning Outcome (CLO) mappings...",
    "Analyzing prerequisite relationships & depth...",
    "Evaluating downstream courses (transitive cascade)...",
    "Checking theoretical vs practical assessment balance...",
    "Detecting critical curriculum gaps & omissions...",
    "Evaluating cohort student readiness friction...",
    "Synthesizing Plan A, B, and C alternatives..."
  ];

  const [currentStepIndex, setCurrentStepIndex] = useState(0);

  useEffect(() => {
    if (currentStepIndex < steps.length) {
      const timer = setTimeout(() => {
        setCurrentStepIndex(prev => prev + 1);
      }, 240); // Fast, realistic progression (~2.2 seconds total)
      return () => clearTimeout(timer);
    } else {
      const finishTimer = setTimeout(() => {
        onComplete();
      }, 350);
      return () => clearTimeout(finishTimer);
    }
  }, [currentStepIndex]);

  return (
    <div className="modal-overlay">
      <div 
        className="modal-content"
        style={{
          maxWidth: "520px",
          textAlign: "center",
          padding: "2.5rem 2rem",
          background: "linear-gradient(180deg, #0F172A, #080D1A)",
          border: "1px solid rgba(56, 189, 248, 0.3)",
          boxShadow: "0 0 35px rgba(56, 189, 248, 0.2)"
        }}
      >
        <div 
          style={{
            width: "56px",
            height: "56px",
            borderRadius: "50%",
            background: "rgba(56, 189, 248, 0.12)",
            color: "var(--accent-blue)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            margin: "0 auto 1.25rem",
            boxShadow: "0 0 20px rgba(56, 189, 248, 0.35)"
          }}
        >
          <Sparkles size={28} />
        </div>

        <h2 style={{ fontSize: "1.35rem", marginBottom: "0.25rem" }}>
          Simulating Academic Change
        </h2>
        <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "1.75rem" }}>
          Acaddie Deterministic Graph &amp; AI Engine analyzing ripple effects...
        </p>

        {/* Steps List */}
        <div style={{ display: "flex", flexDirection: "column", gap: "0.6rem", textAlign: "left", marginBottom: "1.5rem" }}>
          {steps.map((text, idx) => {
            const isFinished = idx < currentStepIndex;
            const isCurrent = idx === currentStepIndex;

            return (
              <div 
                key={idx}
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: "0.75rem",
                  fontSize: "0.85rem",
                  color: isFinished ? "var(--text-primary)" : isCurrent ? "var(--accent-blue)" : "var(--text-muted)",
                  fontWeight: isCurrent ? 600 : 400,
                  opacity: isFinished ? 1 : isCurrent ? 1 : 0.45,
                  transition: "all 0.2s ease"
                }}
              >
                {isFinished ? (
                  <CheckCircle2 size={16} color="#10B981" />
                ) : isCurrent ? (
                  <Loader2 size={16} className="spin" color="#38BDF8" />
                ) : (
                  <div style={{ width: "16px", height: "16px", borderRadius: "50%", border: "1px solid var(--text-muted)", opacity: 0.5 }} />
                )}
                <span>{text}</span>
              </div>
            );
          })}
        </div>

        <div style={{ fontSize: "0.75rem", color: "var(--text-muted)" }}>
          OBE Curriculum Graph v2025 • Traversal depth: 4 hops
        </div>
      </div>
    </div>
  );
}
