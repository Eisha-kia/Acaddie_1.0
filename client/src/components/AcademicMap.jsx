import React, { useState } from "react";
import { 
  ZoomIn, 
  ZoomOut, 
  RotateCcw, 
  Layers, 
  Sliders, 
  ArrowRight, 
  BookOpen, 
  CheckCircle2, 
  AlertTriangle, 
  HelpCircle,
  X
} from "lucide-react";

export default function AcademicMap({ 
  curriculum, 
  activeSimulation, 
  onSimulateCourse, 
  onOpenEvidence 
}) {
  const [zoom, setZoom] = useState(1);
  const [selectedCourse, setSelectedCourse] = useState(null);
  const [filterRiskOnly, setFilterRiskOnly] = useState(false);

  if (!curriculum || !curriculum.courses) {
    return <div className="card">Loading academic curriculum graph...</div>;
  }

  // Pre-calculated node coordinates for an elegant tree layout
  const nodePositions = {
    "CSE-101": { x: 100, y: 270 },
    "CSE-207": { x: 320, y: 270 },
    "CSE-301": { x: 550, y: 160 },
    "CSE-305": { x: 550, y: 380 },
    "CSE-307": { x: 550, y: 490 },
    "CSE-401": { x: 780, y: 160 },
    "CSE-405": { x: 1000, y: 270 }
  };

  // Pre-calculated edges (prerequisite -> target)
  const edges = [
    { from: "CSE-101", to: "CSE-207" },
    { from: "CSE-207", to: "CSE-301" },
    { from: "CSE-207", to: "CSE-305" },
    { from: "CSE-207", to: "CSE-307" },
    { from: "CSE-301", to: "CSE-401" },
    { from: "CSE-401", to: "CSE-405" },
    { from: "CSE-301", to: "CSE-405" }
  ];

  // Lookup simulation impact per node if active
  const getSimulationImpact = (courseId) => {
    if (!activeSimulation || !activeSimulation.rippleEffect) return null;
    return activeSimulation.rippleEffect.find(r => r.nodeId === courseId);
  };

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "1.5rem" }}>
      {/* Map Header & Controls */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", flexWrap: "wrap", gap: "1rem" }}>
        <div>
          <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
            <span className="badge badge-blue">Interactive Graph</span>
            {activeSimulation && (
              <span className="badge badge-high">
                ⚡ Active Simulation Ripple Overlay
              </span>
            )}
          </div>
          <h2 style={{ fontSize: "1.6rem", marginTop: "4px" }}>Department Academic Dependency Map</h2>
          <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)" }}>
            BSc Computer Science curriculum directed dependency graph. Click any course to inspect topics, CLOs, or simulate an academic change.
          </p>
        </div>

        <div style={{ display: "flex", alignItems: "center", gap: "0.75rem" }}>
          {activeSimulation && (
            <button 
              className={`btn btn-sm ${filterRiskOnly ? "btn-primary" : "btn-secondary"}`}
              onClick={() => setFilterRiskOnly(!filterRiskOnly)}
            >
              {filterRiskOnly ? "Show All Courses" : "Filter Affected Paths Only"}
            </button>
          )}

          <div style={{ display: "flex", alignItems: "center", gap: "0.25rem", background: "var(--bg-tertiary)", padding: "4px", borderRadius: "var(--radius-sm)" }}>
            <button className="map-ctrl-btn" onClick={() => setZoom(prev => Math.min(prev + 0.15, 1.5))} title="Zoom In">
              <ZoomIn size={16} />
            </button>
            <button className="map-ctrl-btn" onClick={() => setZoom(prev => Math.max(prev - 0.15, 0.7))} title="Zoom Out">
              <ZoomOut size={16} />
            </button>
            <button className="map-ctrl-btn" onClick={() => setZoom(1)} title="Reset Zoom">
              <RotateCcw size={16} />
            </button>
          </div>
        </div>
      </div>

      {/* Main Canvas Area */}
      <div className="academic-map-container" style={{ position: "relative" }}>
        {/* SVG Graph Canvas */}
        <svg 
          className="graph-canvas"
          viewBox="0 0 1150 600"
          style={{ transform: `scale(${zoom})`, transformOrigin: "center center", transition: "transform 0.2s ease" }}
        >
          <defs>
            {/* Standard arrow marker */}
            <marker id="arrow" viewBox="0 0 10 10" refX="28" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
              <path d="M 0 1 L 8 5 L 0 9 z" fill="rgba(148, 163, 184, 0.5)" />
            </marker>

            {/* Pulsing red ripple arrow marker */}
            <marker id="arrow-crimson" viewBox="0 0 10 10" refX="28" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
              <path d="M 0 1 L 8 5 L 0 9 z" fill="#EF4444" />
            </marker>

            {/* Amber arrow marker */}
            <marker id="arrow-amber" viewBox="0 0 10 10" refX="28" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
              <path d="M 0 1 L 8 5 L 0 9 z" fill="#F59E0B" />
            </marker>

            {/* Background grid */}
            <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
              <path d="M 40 0 L 0 0 0 40" fill="none" stroke="rgba(255, 255, 255, 0.03)" strokeWidth="1" />
            </pattern>
          </defs>

          <rect width="100%" height="100%" fill="url(#grid)" />

          {/* Render Edges */}
          {edges.map((edge, idx) => {
            const start = nodePositions[edge.from];
            const end = nodePositions[edge.to];
            if (!start || !end) return null;

            const simStart = getSimulationImpact(edge.from);
            const simEnd = getSimulationImpact(edge.to);
            const isRipplePath = simStart && simEnd;

            // Curved cubic bezier paths
            const midX = (start.x + end.x) / 2;
            const pathD = `M ${start.x} ${start.y} C ${midX} ${start.y}, ${midX} ${end.y}, ${end.x} ${end.y}`;

            return (
              <g key={idx}>
                <path 
                  d={pathD}
                  fill="none"
                  stroke={isRipplePath ? "#EF4444" : "rgba(148, 163, 184, 0.25)"}
                  strokeWidth={isRipplePath ? "3" : "1.75"}
                  strokeDasharray={isRipplePath ? "6,4" : "none"}
                  markerEnd={isRipplePath ? "url(#arrow-crimson)" : "url(#arrow)"}
                  style={isRipplePath ? { animation: "dash 1s linear infinite" } : {}}
                />
              </g>
            );
          })}

          {/* Render Course Nodes */}
          {curriculum.courses.map(course => {
            const pos = nodePositions[course.id] || { x: 500, y: 300 };
            const simImpact = getSimulationImpact(course.id);
            const isSelected = selectedCourse?.id === course.id;

            let strokeColor = "rgba(255, 255, 255, 0.15)";
            let fillColor = "#0F172A";
            let pulseEffect = false;

            if (simImpact) {
              if (simImpact.color === "crimson") {
                strokeColor = "#EF4444";
                fillColor = "rgba(239, 68, 68, 0.18)";
                pulseEffect = true;
              } else if (simImpact.color === "amber") {
                strokeColor = "#F59E0B";
                fillColor = "rgba(245, 158, 11, 0.18)";
                pulseEffect = true;
              } else if (simImpact.color === "emerald") {
                strokeColor = "#10B981";
                fillColor = "rgba(16, 185, 129, 0.18)";
              }
            }

            if (isSelected) {
              strokeColor = "#38BDF8";
            }

            return (
              <g 
                key={course.id}
                transform={`translate(${pos.x - 85}, ${pos.y - 45})`}
                onClick={() => setSelectedCourse(course)}
                style={{ cursor: "pointer" }}
              >
                {/* Node box */}
                <rect 
                  width="170"
                  height="90"
                  rx="12"
                  fill={fillColor}
                  stroke={strokeColor}
                  strokeWidth={isSelected || pulseEffect ? "2.5" : "1.5"}
                  style={{
                    filter: pulseEffect ? "drop-shadow(0 0 12px rgba(239, 68, 68, 0.4))" : "none",
                    transition: "all 0.2s ease"
                  }}
                />

                {/* Course Code */}
                <text 
                  x="15" 
                  y="28" 
                  fill={simImpact ? (simImpact.color === "crimson" ? "#F87171" : "#FBBF24") : "#38BDF8"} 
                  fontSize="13" 
                  fontWeight="800"
                  fontFamily="Inter, sans-serif"
                >
                  {course.code}
                </text>

                {/* Semester tag */}
                <text 
                  x="155" 
                  y="28" 
                  textAnchor="end"
                  fill="var(--text-muted)" 
                  fontSize="11" 
                  fontWeight="600"
                >
                  Sem {course.semester}
                </text>

                {/* Course Name */}
                <text 
                  x="15" 
                  y="48" 
                  fill="#F8FAFC" 
                  fontSize="12" 
                  fontWeight="600"
                  fontFamily="Inter, sans-serif"
                >
                  {course.name.length > 20 ? course.name.substring(0, 18) + "..." : course.name}
                </text>

                {/* Stats row */}
                <text 
                  x="15" 
                  y="72" 
                  fill="var(--text-secondary)" 
                  fontSize="10"
                >
                  {course.credit} Cr • {course.topics.length} Topics • {course.clos.length} CLOs
                </text>

                {/* Simulation Impact Badge on Node */}
                {simImpact && (
                  <g transform="translate(95, 62)">
                    <rect 
                      width="65" 
                      height="18" 
                      rx="4" 
                      fill={simImpact.color === "crimson" ? "#EF4444" : simImpact.color === "amber" ? "#F59E0B" : "#10B981"} 
                    />
                    <text 
                      x="32.5" 
                      y="12.5" 
                      textAnchor="middle" 
                      fill="#FFFFFF" 
                      fontSize="9" 
                      fontWeight="700"
                    >
                      {simImpact.level}
                    </text>
                  </g>
                )}
              </g>
            );
          })}
        </svg>

        {/* Legend Overlay */}
        <div 
          style={{
            position: "absolute",
            bottom: "1.5rem",
            left: "1.5rem",
            background: "rgba(15, 23, 42, 0.9)",
            border: "1px solid var(--border-subtle)",
            borderRadius: "var(--radius-md)",
            padding: "0.85rem 1.25rem",
            fontSize: "0.75rem",
            display: "flex",
            flexDirection: "column",
            gap: "0.4rem",
            backdropFilter: "blur(8px)"
          }}
        >
          <div style={{ fontWeight: 700, color: "var(--text-primary)", marginBottom: "2px" }}>Graph Legend</div>
          <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
            <span style={{ width: "10px", height: "10px", borderRadius: "50%", background: "#EF4444" }} />
            <span>High Impact / Source Modification</span>
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
            <span style={{ width: "10px", height: "10px", borderRadius: "50%", background: "#F59E0B" }} />
            <span>Medium Downstream Disruption</span>
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
            <span style={{ width: "10px", height: "10px", borderRadius: "50%", background: "#10B981" }} />
            <span>Low Risk / Enriched Course</span>
          </div>
        </div>
      </div>

      {/* Selected Course Inspector Drawer */}
      {selectedCourse && (
        <div 
          className="card"
          style={{
            border: "1px solid rgba(56, 189, 248, 0.4)",
            background: "rgba(15, 23, 42, 0.95)"
          }}
        >
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "1rem" }}>
            <div style={{ display: "flex", alignItems: "center", gap: "0.75rem" }}>
              <span className="badge badge-blue">{selectedCourse.code}</span>
              <h3 style={{ fontSize: "1.3rem" }}>{selectedCourse.name}</h3>
              <span style={{ color: "var(--text-muted)", fontSize: "0.85rem" }}>
                Semester {selectedCourse.semester} • {selectedCourse.credit} Credits • {selectedCourse.type}
              </span>
            </div>
            <div style={{ display: "flex", alignItems: "center", gap: "0.75rem" }}>
              <button 
                className="btn btn-primary btn-sm"
                onClick={() => onSimulateCourse(selectedCourse.id)}
              >
                <Sliders size={14} /> Simulate Change on this Course
              </button>
              <button 
                style={{ background: "transparent", border: "none", color: "var(--text-muted)", cursor: "pointer" }}
                onClick={() => setSelectedCourse(null)}
              >
                <X size={18} />
              </button>
            </div>
          </div>

          <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "1.25rem" }}>
            {selectedCourse.description}
          </p>

          {/* Topics & CLOs Grid */}
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "1.5rem" }}>
            {/* Topics */}
            <div>
              <h4 style={{ fontSize: "0.95rem", color: "var(--accent-blue)", marginBottom: "0.75rem" }}>
                Syllabus Topics ({selectedCourse.topics.length})
              </h4>
              <div style={{ display: "flex", flexDirection: "column", gap: "0.5rem" }}>
                {selectedCourse.topics.map((t, idx) => (
                  <div 
                    key={idx}
                    style={{
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "space-between",
                      padding: "0.5rem 0.75rem",
                      background: "rgba(30, 41, 59, 0.4)",
                      borderRadius: "var(--radius-sm)",
                      fontSize: "0.8rem"
                    }}
                  >
                    <span>{t.name}</span>
                    <span style={{ color: "var(--text-muted)", fontSize: "0.75rem" }}>{t.weeks} wks</span>
                  </div>
                ))}
              </div>
            </div>

            {/* CLOs */}
            <div>
              <h4 style={{ fontSize: "0.95rem", color: "#A855F7", marginBottom: "0.75rem" }}>
                Course Learning Outcomes (CLOs) ({selectedCourse.clos.length})
              </h4>
              <div style={{ display: "flex", flexDirection: "column", gap: "0.5rem" }}>
                {selectedCourse.clos.map((clo, idx) => (
                  <div 
                    key={idx}
                    style={{
                      padding: "0.5rem 0.75rem",
                      background: "rgba(30, 41, 59, 0.4)",
                      borderRadius: "var(--radius-sm)",
                      fontSize: "0.8rem"
                    }}
                  >
                    <div style={{ fontWeight: 600, color: "var(--text-primary)", marginBottom: "2px" }}>
                      {clo.id} <span style={{ color: "#C084FC", fontSize: "0.75rem" }}>[{clo.bloomLevel}]</span>
                    </div>
                    <div style={{ color: "var(--text-secondary)", fontSize: "0.75rem" }}>
                      {clo.description}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
