import React, { useState } from "react";
import { BookOpen, Sliders, ChevronDown, ChevronUp, Layers, CheckCircle2, ArrowRight } from "lucide-react";

export default function CourseCatalog({ curriculum, onSimulateCourse }) {
  const [expandedCourseId, setExpandedCourseId] = useState("CSE-207");
  const [filterSemester, setFilterSemester] = useState("ALL");

  if (!curriculum || !curriculum.courses) {
    return <div className="card">Loading courses...</div>;
  }

  const courses = curriculum.courses;
  const filteredCourses = filterSemester === "ALL" 
    ? courses 
    : courses.filter(c => c.semester === Number(filterSemester));

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "2rem" }}>
      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", flexWrap: "wrap", gap: "1rem" }}>
        <div>
          <span className="badge badge-blue">Department Course Catalog</span>
          <h1 style={{ fontSize: "2rem", marginTop: "4px" }}>Courses, Syllabi &amp; Outcomes</h1>
          <p style={{ fontSize: "0.95rem", color: "var(--text-secondary)" }}>
            Inspect syllabus topics, Course Learning Outcomes (CLOs), and prerequisite relationships for {curriculum.university?.department}.
          </p>
        </div>

        {/* Filter */}
        <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
          <span style={{ fontSize: "0.8rem", color: "var(--text-muted)", fontWeight: 600 }}>Filter Semester:</span>
          <select 
            value={filterSemester}
            onChange={(e) => setFilterSemester(e.target.value)}
            style={{
              padding: "0.4rem 0.85rem",
              background: "var(--bg-tertiary)",
              border: "1px solid var(--border-subtle)",
              borderRadius: "var(--radius-sm)",
              color: "var(--text-primary)",
              fontSize: "0.85rem"
            }}
          >
            <option value="ALL">All Semesters (1–7)</option>
            <option value="1">Semester 1</option>
            <option value="3">Semester 3</option>
            <option value="4">Semester 4</option>
            <option value="5">Semester 5</option>
            <option value="6">Semester 6</option>
            <option value="7">Semester 7</option>
          </select>
        </div>
      </div>

      {/* Course List */}
      <div style={{ display: "flex", flexDirection: "column", gap: "1.25rem" }}>
        {filteredCourses.map(course => {
          const isExpanded = expandedCourseId === course.id;

          return (
            <div 
              key={course.id}
              className="card"
              style={{
                transition: "all var(--transition-fast)",
                border: isExpanded ? "1px solid var(--border-focus)" : "1px solid var(--border-subtle)"
              }}
            >
              {/* Course Header Bar */}
              <div 
                style={{
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "space-between",
                  cursor: "pointer",
                  userSelect: "none"
                }}
                onClick={() => setExpandedCourseId(isExpanded ? null : course.id)}
              >
                <div style={{ display: "flex", alignItems: "center", gap: "1rem" }}>
                  <div 
                    style={{
                      width: "44px",
                      height: "44px",
                      borderRadius: "var(--radius-md)",
                      background: "rgba(56, 189, 248, 0.12)",
                      color: "var(--accent-blue)",
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "center",
                      fontWeight: 800,
                      fontSize: "0.85rem"
                    }}
                  >
                    S{course.semester}
                  </div>

                  <div>
                    <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
                      <span className="badge badge-blue">{course.code}</span>
                      <h3 style={{ fontSize: "1.2rem" }}>{course.name}</h3>
                      <span className="badge" style={{ background: "rgba(255, 255, 255, 0.08)", color: "var(--text-muted)" }}>
                        {course.type}
                      </span>
                    </div>
                    <div style={{ fontSize: "0.8rem", color: "var(--text-secondary)", marginTop: "2px" }}>
                      {course.credit} Credits • {course.topics.length} Topics • {course.clos.length} CLOs
                    </div>
                  </div>
                </div>

                <div style={{ display: "flex", alignItems: "center", gap: "1rem" }}>
                  <button 
                    className="btn btn-secondary btn-sm"
                    onClick={(e) => {
                      e.stopPropagation();
                      onSimulateCourse(course.id);
                    }}
                  >
                    <Sliders size={14} /> Simulate Change
                  </button>

                  <div style={{ color: "var(--text-muted)" }}>
                    {isExpanded ? <ChevronUp size={20} /> : <ChevronDown size={20} />}
                  </div>
                </div>
              </div>

              {/* Expanded Syllabus View */}
              {isExpanded && (
                <div style={{ marginTop: "1.5rem", paddingTop: "1.5rem", borderTop: "1px solid var(--border-subtle)" }}>
                  <p style={{ fontSize: "0.9rem", color: "var(--text-secondary)", lineHeight: 1.6, marginBottom: "1.5rem" }}>
                    {course.description}
                  </p>

                  <div style={{ display: "grid", gridTemplateColumns: "1.2fr 1fr", gap: "2rem" }}>
                    {/* Topics Table */}
                    <div>
                      <h4 style={{ fontSize: "1rem", color: "var(--accent-blue)", marginBottom: "0.75rem", display: "flex", alignItems: "center", gap: "0.4rem" }}>
                        <BookOpen size={16} /> Syllabus Topics ({course.topics.length})
                      </h4>
                      <div style={{ display: "flex", flexDirection: "column", gap: "0.5rem" }}>
                        {course.topics.map(t => (
                          <div 
                            key={t.id}
                            style={{
                              display: "flex",
                              alignItems: "center",
                              justifyContent: "space-between",
                              padding: "0.6rem 0.85rem",
                              background: "rgba(30, 41, 59, 0.4)",
                              borderRadius: "var(--radius-sm)",
                              fontSize: "0.85rem"
                            }}
                          >
                            <div>
                              <span style={{ fontWeight: 600 }}>{t.name}</span>
                              {t.importance === "Critical" && (
                                <span className="badge badge-high" style={{ marginLeft: "0.5rem", fontSize: "0.65rem" }}>
                                  Critical Core
                                </span>
                              )}
                            </div>
                            <span style={{ color: "var(--text-muted)", fontSize: "0.75rem" }}>
                              {t.weeks} weeks
                            </span>
                          </div>
                        ))}
                      </div>
                    </div>

                    {/* CLOs and Prerequisites */}
                    <div style={{ display: "flex", flexDirection: "column", gap: "1.5rem" }}>
                      <div>
                        <h4 style={{ fontSize: "1rem", color: "#C084FC", marginBottom: "0.75rem", display: "flex", alignItems: "center", gap: "0.4rem" }}>
                          <Layers size={16} /> Course Learning Outcomes
                        </h4>
                        <div style={{ display: "flex", flexDirection: "column", gap: "0.5rem" }}>
                          {course.clos.map(clo => (
                            <div 
                              key={clo.id}
                              style={{
                                padding: "0.6rem 0.85rem",
                                background: "rgba(30, 41, 59, 0.4)",
                                borderRadius: "var(--radius-sm)",
                                fontSize: "0.8rem"
                              }}
                            >
                              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "2px" }}>
                                <strong style={{ color: "var(--text-primary)" }}>{clo.id}</strong>
                                <span className="badge badge-blue" style={{ fontSize: "0.65rem" }}>
                                  Bloom: {clo.bloomLevel}
                                </span>
                              </div>
                              <div style={{ color: "var(--text-secondary)", fontSize: "0.75rem" }}>
                                {clo.description}
                              </div>
                            </div>
                          ))}
                        </div>
                      </div>

                      {/* Prerequisite Chains */}
                      <div>
                        <h4 style={{ fontSize: "0.85rem", textTransform: "uppercase", color: "var(--text-muted)", marginBottom: "0.5rem" }}>
                          Prerequisite Courses:
                        </h4>
                        <div style={{ display: "flex", gap: "0.5rem", flexWrap: "wrap" }}>
                          {course.prerequisites.length > 0 ? (
                            course.prerequisites.map(p => (
                              <span key={p} className="badge badge-blue">{p}</span>
                            ))
                          ) : (
                            <span style={{ fontSize: "0.8rem", color: "var(--text-muted)" }}>None (Foundational Entry Course)</span>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}
