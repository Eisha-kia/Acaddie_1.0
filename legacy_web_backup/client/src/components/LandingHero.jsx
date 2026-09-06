import React from "react";
import { 
  ArrowRight, 
  Network, 
  SlidersHorizontal, 
  HelpCircle, 
  ShieldCheck, 
  Zap, 
  CheckCircle2, 
  GitCompare, 
  Eye 
} from "lucide-react";

export default function LandingHero({ onStartSimulation, onExploreMap, onRunDemo }) {
  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "3.5rem", padding: "1.5rem 0 3rem" }}>
      {/* Hero Header */}
      <div style={{ textAlign: "center", maxWidth: "900px", margin: "0 auto" }}>
        <div 
          style={{
            display: "inline-flex",
            alignItems: "center",
            gap: "0.5rem",
            padding: "0.4rem 1rem",
            borderRadius: "var(--radius-full)",
            background: "rgba(56, 189, 248, 0.1)",
            border: "1px solid rgba(56, 189, 248, 0.25)",
            color: "var(--accent-blue)",
            fontSize: "0.8rem",
            fontWeight: 700,
            letterSpacing: "0.08em",
            textTransform: "uppercase",
            marginBottom: "1.5rem"
          }}
        >
          <Zap size={14} /> AI-Powered Academic Change Impact Simulator
        </div>

        <h1 
          style={{
            fontSize: "3.5rem",
            lineHeight: 1.15,
            marginBottom: "1.25rem",
            background: "linear-gradient(135deg, #FFFFFF 30%, #93C5FD 70%, #60A5FA 100%)",
            WebkitBackgroundClip: "text",
            WebkitTextFillColor: "transparent"
          }}
        >
          Think. Simulate. Decide.
        </h1>

        <p 
          style={{
            fontSize: "1.25rem",
            color: "var(--text-secondary)",
            lineHeight: 1.6,
            maxWidth: "720px",
            margin: "0 auto 2.25rem"
          }}
        >
          Understand the hidden ripple effects of university curriculum changes across courses, CLOs, prerequisites, and student readiness <em>before</em> you implement them.
        </p>

        <div style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: "1rem", flexWrap: "wrap" }}>
          <button className="btn btn-primary btn-lg" onClick={onStartSimulation}>
            <SlidersHorizontal size={18} /> Start Simulation <ArrowRight size={18} />
          </button>
          <button className="btn btn-secondary btn-lg" onClick={onExploreMap}>
            <Network size={18} /> Explore Academic Map
          </button>
          <button className="btn btn-demo btn-lg" onClick={() => onRunDemo("scenario-1")}>
            <Zap size={18} /> ⚡ 1-Click Judge Demo
          </button>
        </div>
      </div>

      {/* Visual Workflow Cycle */}
      <div 
        style={{
          background: "var(--bg-card)",
          border: "1px solid var(--border-subtle)",
          borderRadius: "var(--radius-xl)",
          padding: "2.25rem",
          boxShadow: "var(--shadow-lg)"
        }}
      >
        <div style={{ textAlign: "center", marginBottom: "1.75rem" }}>
          <span style={{ fontSize: "0.75rem", fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.1em", color: "var(--accent-blue)" }}>
            The Acaddie Philosophy: Google Maps for Academic Decisions
          </span>
          <h3 style={{ fontSize: "1.4rem", marginTop: "4px" }}>“Don't change blindly. Simulate first.”</h3>
        </div>

        <div 
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(180px, 1fr))",
            gap: "1rem",
            alignItems: "center"
          }}
        >
          {[
            { step: "01", title: "Proposed Change", desc: "Faculty proposes removing/altering a topic or assessment." },
            { step: "02", title: "AI Simulation", desc: "Graph engine scans 7 dimensions of curriculum dependencies." },
            { step: "03", title: "Ripple Effect", desc: "Downstream courses & CLO drops are visually illuminated." },
            { step: "04", title: "Why? Evidence", desc: "Every risk is backed by verified syllabus dependency paths." },
            { step: "05", title: "What-If Compare", desc: "Compare Plan A, B, and C to choose the safest path." },
            { step: "06", title: "Faculty Decides", desc: "AI advises with evidence; faculty retains final authority." }
          ].map((item, idx) => (
            <div 
              key={idx}
              style={{
                background: "rgba(30, 41, 59, 0.45)",
                border: "1px solid var(--border-subtle)",
                borderRadius: "var(--radius-md)",
                padding: "1.25rem 1rem",
                textAlign: "left",
                position: "relative"
              }}
            >
              <div style={{ fontSize: "0.75rem", fontWeight: 800, color: "var(--accent-blue)", marginBottom: "4px" }}>
                STEP {item.step}
              </div>
              <div style={{ fontWeight: 700, fontSize: "0.95rem", color: "var(--text-primary)", marginBottom: "6px" }}>
                {item.title}
              </div>
              <div style={{ fontSize: "0.75rem", color: "var(--text-secondary)", lineHeight: 1.4 }}>
                {item.desc}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* 3 Core Value Cards */}
      <div 
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))",
          gap: "1.5rem"
        }}
      >
        <div className="card">
          <div style={{ color: "#EF4444", marginBottom: "0.75rem" }}>
            <Network size={28} />
          </div>
          <h3 style={{ fontSize: "1.2rem", marginBottom: "0.5rem" }}>Curriculum Ripple Effects</h3>
          <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", lineHeight: 1.6 }}>
            Curriculum changes rarely affect only one course. Removing <em>Graph Algorithms</em> from Data Structures ripples across Algorithms, Artificial Intelligence, and Machine Learning across 3 subsequent semesters.
          </p>
        </div>

        <div className="card">
          <div style={{ color: "#FBBF24", marginBottom: "0.75rem" }}>
            <HelpCircle size={28} />
          </div>
          <h3 style={{ fontSize: "1.2rem", marginBottom: "0.5rem" }}>The "Why?" Evidence Layer</h3>
          <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", lineHeight: 1.6 }}>
            No black-box hallucinated percentages. Click "Why?" on any finding to inspect verified structural course syllabus dependencies, mapped Bloom's Taxonomy CLOs, and ABET accreditation requirements.
          </p>
        </div>

        <div className="card">
          <div style={{ color: "#34D399", marginBottom: "0.75rem" }}>
            <GitCompare size={28} />
          </div>
          <h3 style={{ fontSize: "1.2rem", marginBottom: "0.5rem" }}>What-If Plan Alternatives</h3>
          <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", lineHeight: 1.6 }}>
            Instead of simply blocking changes, Acaddie synthesizes safer academic compromises: <strong>Plan B (Scope Reduction)</strong> or <strong>Plan C (Curricular Relocation)</strong>, highlighting the route with lowest modeled disruption.
          </p>
        </div>
      </div>
    </div>
  );
}
