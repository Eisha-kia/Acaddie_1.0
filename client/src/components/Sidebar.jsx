import React from "react";
import { 
  LayoutDashboard, 
  Network, 
  SlidersHorizontal, 
  BookOpen, 
  GitCompare, 
  History, 
  FileText, 
  HelpCircle,
  Award
} from "lucide-react";

export default function Sidebar({ currentTab, setCurrentTab, activeSimulation }) {
  const navItems = [
    { id: "dashboard", label: "Decision Center", icon: LayoutDashboard },
    { id: "map", label: "Academic Map", icon: Network },
    { id: "studio", label: "Simulation Studio", icon: SlidersHorizontal },
    { id: "courses", label: "Courses & Syllabi", icon: BookOpen },
    { id: "comparison", label: "What-If Comparison", icon: GitCompare, disabled: !activeSimulation },
    { id: "history", label: "Simulation History", icon: History },
    { id: "report", label: "Academic Report", icon: FileText, disabled: !activeSimulation }
  ];

  return (
    <aside className="sidebar">
      <div className="sidebar-heading">Navigation</div>
      
      {navItems.map(item => {
        const Icon = item.icon;
        const isActive = currentTab === item.id;
        return (
          <div
            key={item.id}
            className={`sidebar-nav-item ${isActive ? "active" : ""} ${item.disabled ? "disabled" : ""}`}
            style={{ opacity: item.disabled ? 0.4 : 1, pointerEvents: item.disabled ? "none" : "auto" }}
            onClick={() => setCurrentTab(item.id)}
          >
            <Icon size={18} />
            <span>{item.label}</span>
          </div>
        );
      })}

      <div style={{ marginTop: "auto" }}>
        <div 
          style={{
            background: "rgba(30, 41, 59, 0.4)",
            border: "1px solid var(--border-subtle)",
            borderRadius: "var(--radius-md)",
            padding: "1rem",
            fontSize: "0.75rem",
            color: "var(--text-secondary)"
          }}
        >
          <div style={{ display: "flex", alignItems: "center", gap: "0.4rem", color: "var(--text-primary)", fontWeight: 700, marginBottom: "4px" }}>
            <Award size={14} color="#FBBF24" /> AUST CSE Carnival &lt;8.0&gt;
          </div>
          <div style={{ color: "var(--text-muted)", fontSize: "0.7rem", lineHeight: 1.4 }}>
            AI for Academic Life Hackathon entry: <strong>Acaddie</strong>.
          </div>
        </div>
      </div>
    </aside>
  );
}
