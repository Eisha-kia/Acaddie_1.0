import React, { useState } from "react";
import { 
  Compass, 
  Sparkles, 
  Zap, 
  ChevronDown, 
  ShieldAlert, 
  Sliders, 
  CheckCircle2, 
  MapPin, 
  Layers 
} from "lucide-react";

export default function Navbar({ 
  currentTab, 
  setCurrentTab, 
  engineStatus, 
  onRunDemoScenario 
}) {
  const [demoMenuOpen, setDemoMenuOpen] = useState(false);

  return (
    <header className="navbar">
      {/* Brand */}
      <div className="nav-brand" onClick={() => setCurrentTab("landing")}>
        <div className="nav-logo-icon">
          <Layers size={22} />
        </div>
        <div className="nav-brand-text">
          <h1>ACADDIE</h1>
          <span className="nav-tagline">Think. Simulate. Decide.</span>
        </div>
      </div>

      {/* Center Nav Links */}
      <div style={{ display: "flex", alignItems: "center", gap: "1.5rem" }}>
        <button 
          className={`btn btn-sm ${currentTab === "dashboard" ? "btn-primary" : "btn-secondary"}`}
          onClick={() => setCurrentTab("dashboard")}
        >
          <Compass size={16} /> Decision Center
        </button>
        <button 
          className={`btn btn-sm ${currentTab === "map" ? "btn-primary" : "btn-secondary"}`}
          onClick={() => setCurrentTab("map")}
        >
          <MapPin size={16} /> Academic Map
        </button>
        <button 
          className={`btn btn-sm ${currentTab === "studio" ? "btn-primary" : "btn-secondary"}`}
          onClick={() => setCurrentTab("studio")}
        >
          <Sliders size={16} /> New Simulation
        </button>
      </div>

      {/* Right Controls */}
      <div className="nav-right-actions">
        {/* Engine Status Badge */}
        <div className={`engine-badge ${engineStatus?.hasApiKey ? "ai-mode" : ""}`} title="Active simulation engine">
          <span className="engine-dot" />
          {engineStatus?.hasApiKey ? "Gemini 2.5 AI Mode" : "Local Deterministic Engine"}
        </div>

        {/* 1-Click Judge Demo Dropdown */}
        <div style={{ position: "relative" }}>
          <button 
            className="btn btn-demo btn-sm"
            onClick={() => setDemoMenuOpen(!demoMenuOpen)}
          >
            <Zap size={16} /> ⚡ Judge Demo <ChevronDown size={14} />
          </button>

          {demoMenuOpen && (
            <div 
              style={{
                position: "absolute",
                top: "120%",
                right: 0,
                width: "320px",
                background: "var(--bg-secondary)",
                border: "1px solid var(--border-strong)",
                borderRadius: "var(--radius-md)",
                boxShadow: "var(--shadow-lg)",
                padding: "0.5rem",
                zIndex: 200
              }}
            >
              <div style={{ padding: "0.5rem 0.75rem", fontSize: "0.75rem", color: "var(--text-muted)", fontWeight: 700, textTransform: "uppercase" }}>
                1-Click Benchmark Scenarios
              </div>

              <div 
                style={{
                  padding: "0.65rem 0.75rem",
                  borderRadius: "var(--radius-sm)",
                  cursor: "pointer",
                  transition: "var(--transition-fast)"
                }}
                className="hover-bg"
                onClick={() => {
                  onRunDemoScenario("scenario-1");
                  setDemoMenuOpen(false);
                }}
              >
                <div style={{ display: "flex", alignItems: "center", gap: "0.4rem", fontWeight: 600, color: "#F87171", fontSize: "0.85rem" }}>
                  <ShieldAlert size={14} /> Scenario 1: Remove Graph Algorithms
                </div>
                <div style={{ fontSize: "0.75rem", color: "var(--text-secondary)", marginTop: "2px" }}>
                  High Risk • 78/100 • 4-course cascade (Data Structures ➔ Algorithms ➔ AI)
                </div>
              </div>

              <div 
                style={{
                  padding: "0.65rem 0.75rem",
                  borderRadius: "var(--radius-sm)",
                  cursor: "pointer"
                }}
                className="hover-bg"
                onClick={() => {
                  onRunDemoScenario("scenario-2");
                  setDemoMenuOpen(false);
                }}
              >
                <div style={{ display: "flex", alignItems: "center", gap: "0.4rem", fontWeight: 600, color: "#FBBF24", fontSize: "0.85rem" }}>
                  <Sliders size={14} /> Scenario 2: Shift ML Practical Marks
                </div>
                <div style={{ fontSize: "0.75rem", color: "var(--text-secondary)", marginTop: "2px" }}>
                  Medium Risk • 42/100 • Practical marks 10% ➔ 25% in Machine Learning
                </div>
              </div>

              <div 
                style={{
                  padding: "0.65rem 0.75rem",
                  borderRadius: "var(--radius-sm)",
                  cursor: "pointer"
                }}
                className="hover-bg"
                onClick={() => {
                  onRunDemoScenario("scenario-3");
                  setDemoMenuOpen(false);
                }}
              >
                <div style={{ display: "flex", alignItems: "center", gap: "0.4rem", fontWeight: 600, color: "#34D399", fontSize: "0.85rem" }}>
                  <CheckCircle2 size={14} /> Scenario 3: Add Python to AI
                </div>
                <div style={{ fontSize: "0.75rem", color: "var(--text-secondary)", marginTop: "2px" }}>
                  Low Risk • 22/100 • Positive student readiness for Machine Learning
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
