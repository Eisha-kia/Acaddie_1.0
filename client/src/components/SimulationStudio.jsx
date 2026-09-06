import React, { useState, useEffect } from "react";
import { 
  Sliders, 
  ArrowRight, 
  Zap, 
  BookOpen, 
  HelpCircle, 
  Layers, 
  SlidersHorizontal,
  CheckCircle2,
  AlertCircle
} from "lucide-react";

export default function SimulationStudio({ 
  curriculum, 
  initialCourseId = null, 
  onRunSimulation 
}) {
  const courses = curriculum?.courses || [];

  const [selectedCourseId, setSelectedCourseId] = useState(initialCourseId || "CSE-207");
  const [action, setAction] = useState("REMOVE_TOPIC");
  const [topicId, setTopicId] = useState("DS-6");
  const [newTopicName, setNewTopicName] = useState("");
  const [newTopicWeeks, setNewTopicWeeks] = useState(2.0);
  const [practicalMarks, setPracticalMarks] = useState(25);
  const [targetCourseId, setTargetCourseId] = useState("CSE-301");
  const [facultyReason, setFacultyReason] = useState("");

  const currentCourse = courses.find(c => c.id === selectedCourseId) || courses[0];

  useEffect(() => {
    if (initialCourseId) {
      setSelectedCourseId(initialCourseId);
    }
  }, [initialCourseId]);

  // When course changes, pick first topic as default
  useEffect(() => {
    if (currentCourse && currentCourse.topics.length > 0) {
      if (selectedCourseId === "CSE-207") {
        setTopicId("DS-6"); // Default to Graph Algorithms for demo
      } else {
        setTopicId(currentCourse.topics[0].id);
      }
    }
  }, [selectedCourseId]);

  const handleSubmit = (e) => {
    e.preventDefault();
    onRunSimulation({
      courseId: selectedCourseId,
      action,
      topicId,
      newTopicName,
      newTopicWeeks,
      assessmentChanges: action === "CHANGE_ASSESSMENT" ? { practical: practicalMarks } : null,
      targetCourseId,
      facultyReason
    });
  };

  const loadPreset = (scenarioNum) => {
    if (scenarioNum === 1) {
      setSelectedCourseId("CSE-207");
      setAction("REMOVE_TOPIC");
      setTopicId("DS-6");
      setFacultyReason("Course syllabus is congested; evaluating offloading graphs to save 3.5 weeks.");
    } else if (scenarioNum === 2) {
      setSelectedCourseId("CSE-405");
      setAction("CHANGE_ASSESSMENT");
      setPracticalMarks(25);
      setFacultyReason("Industry recruiters emphasize hands-on model training over theoretical proofs.");
    } else if (scenarioNum === 3) {
      setSelectedCourseId("CSE-401");
      setAction("ADD_TOPIC");
      setNewTopicName("Python Programming for Scientific Computing");
      setNewTopicWeeks(2.0);
      setFacultyReason("Modernize AI tooling with NumPy, PyTorch, and search visualization scripts.");
    }
  };

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "2rem", maxWidth: "1000px", margin: "0 auto" }}>
      {/* Header */}
      <div>
        <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
          <span className="badge badge-blue">Change Impact Studio</span>
        </div>
        <h1 style={{ fontSize: "2rem", marginTop: "4px" }}>Simulate an Academic Change</h1>
        <p style={{ fontSize: "0.95rem", color: "var(--text-secondary)" }}>
          Configure a proposed course or syllabus modification. Acaddie will calculate the ripple effect across the entire curriculum.
        </p>
      </div>

      {/* 1-Click Quick Benchmark Presets */}
      <div 
        style={{
          display: "flex",
          alignItems: "center",
          gap: "0.75rem",
          padding: "0.85rem 1.25rem",
          background: "rgba(15, 23, 42, 0.6)",
          border: "1px solid var(--border-subtle)",
          borderRadius: "var(--radius-lg)",
          flexWrap: "wrap"
        }}
      >
        <span style={{ fontSize: "0.8rem", fontWeight: 700, color: "var(--text-muted)", textTransform: "uppercase" }}>
          Quick Benchmark Presets:
        </span>
        <button className="btn btn-secondary btn-sm" onClick={() => loadPreset(1)}>
          🔴 Scenario 1: Remove Graph Algorithms
        </button>
        <button className="btn btn-secondary btn-sm" onClick={() => loadPreset(2)}>
          🟡 Scenario 2: Shift ML Practical Marks
        </button>
        <button className="btn btn-secondary btn-sm" onClick={() => loadPreset(3)}>
          🟢 Scenario 3: Add Python to AI
        </button>
      </div>

      {/* Main Simulation Configuration Form */}
      <form onSubmit={handleSubmit} className="card" style={{ display: "flex", flexDirection: "column", gap: "1.75rem" }}>
        {/* Step 1: Select Course */}
        <div>
          <label style={{ display: "block", fontSize: "0.85rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-secondary)", marginBottom: "0.5rem" }}>
            Step 1: Select Target Course
          </label>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(180px, 1fr))", gap: "0.75rem" }}>
            {courses.map(c => {
              const isSelected = c.id === selectedCourseId;
              return (
                <div 
                  key={c.id}
                  onClick={() => setSelectedCourseId(c.id)}
                  style={{
                    padding: "0.85rem 1rem",
                    borderRadius: "var(--radius-md)",
                    border: `1px solid ${isSelected ? "var(--accent-blue)" : "var(--border-subtle)"}`,
                    background: isSelected ? "rgba(56, 189, 248, 0.12)" : "rgba(30, 41, 59, 0.4)",
                    cursor: "pointer",
                    transition: "all 0.15s ease"
                  }}
                >
                  <div style={{ fontSize: "0.85rem", fontWeight: 700, color: isSelected ? "#38BDF8" : "var(--text-primary)" }}>
                    {c.code}
                  </div>
                  <div style={{ fontSize: "0.75rem", color: "var(--text-secondary)", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
                    {c.name}
                  </div>
                  <div style={{ fontSize: "0.7rem", color: "var(--text-muted)", marginTop: "2px" }}>
                    Sem {c.semester} • {c.credit} Cr
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Step 2: Select Change Type */}
        <div>
          <label style={{ display: "block", fontSize: "0.85rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-secondary)", marginBottom: "0.5rem" }}>
            Step 2: Select Academic Change Type
          </label>
          <select 
            value={action}
            onChange={(e) => setAction(e.target.value)}
            style={{
              width: "100%",
              padding: "0.75rem 1rem",
              background: "var(--bg-tertiary)",
              border: "1px solid var(--border-strong)",
              borderRadius: "var(--radius-md)",
              color: "var(--text-primary)",
              fontSize: "0.95rem",
              fontFamily: "var(--font-body)"
            }}
          >
            <option value="REMOVE_TOPIC">1. Remove Topic (Assess curriculum gap &amp; downstream breakage)</option>
            <option value="ADD_TOPIC">2. Add Topic (Assess modernization, workload &amp; readiness)</option>
            <option value="CHANGE_ASSESSMENT">3. Change Assessment Marks (Theory vs Practical re-weighting)</option>
            <option value="INCREASE_COVERAGE">4. Increase Topic Coverage (Add instructional contact weeks)</option>
            <option value="DECREASE_COVERAGE">5. Decrease Topic Coverage (Compress topic hours)</option>
            <option value="MOVE_TOPIC">6. Move Topic (Shift topic to a downstream course)</option>
            <option value="CHANGE_PREREQUISITE">7. Change Prerequisite (Modify course entry requirement)</option>
            <option value="CHANGE_CLO">8. Change CLO Alignment (Reassign topic to different CLO)</option>
            <option value="REPLACE_TOPIC">9. Replace Topic (Substitute legacy topic with modern equivalent)</option>
          </select>
        </div>

        {/* Step 3: Parameter Configuration based on Action */}
        <div 
          style={{
            background: "rgba(15, 23, 42, 0.5)",
            border: "1px solid var(--border-subtle)",
            borderRadius: "var(--radius-md)",
            padding: "1.25rem"
          }}
        >
          <div style={{ fontSize: "0.85rem", fontWeight: 700, textTransform: "uppercase", color: "var(--accent-blue)", marginBottom: "1rem" }}>
            Step 3: Configure Parameters for {currentCourse?.code}
          </div>

          {action === "REMOVE_TOPIC" && (
            <div>
              <label style={{ display: "block", fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "0.4rem" }}>
                Select Topic to Remove:
              </label>
              <select 
                value={topicId}
                onChange={(e) => setTopicId(e.target.value)}
                style={{
                  width: "100%",
                  padding: "0.75rem 1rem",
                  background: "var(--bg-tertiary)",
                  border: "1px solid var(--border-strong)",
                  borderRadius: "var(--radius-md)",
                  color: "var(--text-primary)",
                  fontSize: "0.9rem"
                }}
              >
                {currentCourse?.topics.map(t => (
                  <option key={t.id} value={t.id}>
                    {t.name} ({t.weeks} weeks • {t.importance})
                  </option>
                ))}
              </select>
            </div>
          )}

          {action === "ADD_TOPIC" && (
            <div style={{ display: "grid", gridTemplateColumns: "2fr 1fr", gap: "1rem" }}>
              <div>
                <label style={{ display: "block", fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "0.4rem" }}>
                  New Topic Title:
                </label>
                <input 
                  type="text"
                  placeholder="e.g. Python Programming for Scientific Computing"
                  value={newTopicName}
                  onChange={(e) => setNewTopicName(e.target.value)}
                  style={{
                    width: "100%",
                    padding: "0.75rem 1rem",
                    background: "var(--bg-tertiary)",
                    border: "1px solid var(--border-strong)",
                    borderRadius: "var(--radius-md)",
                    color: "var(--text-primary)",
                    fontSize: "0.9rem"
                  }}
                />
              </div>
              <div>
                <label style={{ display: "block", fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "0.4rem" }}>
                  Instructional Weeks:
                </label>
                <input 
                  type="number"
                  step="0.5"
                  min="0.5"
                  max="5.0"
                  value={newTopicWeeks}
                  onChange={(e) => setNewTopicWeeks(e.target.value)}
                  style={{
                    width: "100%",
                    padding: "0.75rem 1rem",
                    background: "var(--bg-tertiary)",
                    border: "1px solid var(--border-strong)",
                    borderRadius: "var(--radius-md)",
                    color: "var(--text-primary)",
                    fontSize: "0.9rem"
                  }}
                />
              </div>
            </div>
          )}

          {action === "CHANGE_ASSESSMENT" && (
            <div>
              <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "0.4rem", fontSize: "0.85rem" }}>
                <span>Proposed Practical Weight: <strong style={{ color: "#38BDF8" }}>{practicalMarks}%</strong></span>
                <span>Predicted Theory Weight: <strong style={{ color: "var(--text-secondary)" }}>{100 - practicalMarks}%</strong></span>
              </div>
              <input 
                type="range"
                min="10"
                max="60"
                step="5"
                value={practicalMarks}
                onChange={(e) => setPracticalMarks(Number(e.target.value))}
                style={{ width: "100%", cursor: "pointer" }}
              />
              <div style={{ fontSize: "0.75rem", color: "var(--text-muted)", marginTop: "4px" }}>
                Current Baseline in {currentCourse.code}: {currentCourse.assessmentRatio.practical}% Practical / {currentCourse.assessmentRatio.theory}% Theory
              </div>
            </div>
          )}

          {action === "MOVE_TOPIC" && (
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "1rem" }}>
              <div>
                <label style={{ display: "block", fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "0.4rem" }}>
                  Topic to Move:
                </label>
                <select 
                  value={topicId}
                  onChange={(e) => setTopicId(e.target.value)}
                  style={{
                    width: "100%",
                    padding: "0.75rem 1rem",
                    background: "var(--bg-tertiary)",
                    border: "1px solid var(--border-strong)",
                    borderRadius: "var(--radius-md)",
                    color: "var(--text-primary)"
                  }}
                >
                  {currentCourse?.topics.map(t => (
                    <option key={t.id} value={t.id}>{t.name}</option>
                  ))}
                </select>
              </div>
              <div>
                <label style={{ display: "block", fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "0.4rem" }}>
                  Destination Course:
                </label>
                <select 
                  value={targetCourseId}
                  onChange={(e) => setTargetCourseId(e.target.value)}
                  style={{
                    width: "100%",
                    padding: "0.75rem 1rem",
                    background: "var(--bg-tertiary)",
                    border: "1px solid var(--border-strong)",
                    borderRadius: "var(--radius-md)",
                    color: "var(--text-primary)"
                  }}
                >
                  {courses.filter(c => c.id !== selectedCourseId).map(c => (
                    <option key={c.id} value={c.id}>{c.code} - {c.name}</option>
                  ))}
                </select>
              </div>
            </div>
          )}
        </div>

        {/* Step 4: Optional Faculty Rationale */}
        <div>
          <label style={{ display: "block", fontSize: "0.85rem", fontWeight: 700, textTransform: "uppercase", color: "var(--text-secondary)", marginBottom: "0.4rem" }}>
            Step 4: Academic Rationale / Reason (Optional)
          </label>
          <textarea 
            rows="2"
            placeholder="e.g. Updating syllabus for OBE 2026 accreditation, or reducing syllabus congestion..."
            value={facultyReason}
            onChange={(e) => setFacultyReason(e.target.value)}
            style={{
              width: "100%",
              padding: "0.75rem 1rem",
              background: "var(--bg-tertiary)",
              border: "1px solid var(--border-strong)",
              borderRadius: "var(--radius-md)",
              color: "var(--text-primary)",
              fontSize: "0.9rem",
              fontFamily: "var(--font-body)",
              resize: "vertical"
            }}
          />
        </div>

        {/* Submit Button */}
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", paddingTop: "0.5rem" }}>
          <div style={{ fontSize: "0.8rem", color: "var(--text-muted)" }}>
            ⚡ Real graph traversal + 7-factor impact analysis
          </div>
          <button type="submit" className="btn btn-primary btn-lg">
            <Zap size={18} /> Run AI Simulation <ArrowRight size={18} />
          </button>
        </div>
      </form>
    </div>
  );
}
