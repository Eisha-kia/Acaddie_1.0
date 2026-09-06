# ACADDIE: AI-Powered Academic Change Impact Simulator — Walkthrough

Tagline: **“Think. Simulate. Decide.”**  
Philosophy: **“Google Maps for Academic Decisions — Don't change blindly. Simulate first.”**

ACADDIE was built as an academic decision-support platform for university faculty participating in the **AUST CSE Carnival <8.0> — AI Build Hackathon**.

---

## 1. What Was Built

### Core Workflow
$$\text{Academic Data} \longrightarrow \text{Proposed Change} \longrightarrow \text{AI Simulation} \longrightarrow \text{Ripple Effect} \longrightarrow \text{What-If Comparison} \longrightarrow \text{Faculty Decision}$$

### Key Capabilities
1. **Deterministic Graph & Traversal Engine**:
   - Models the complete **BSc in Computer Science** curriculum (7 core courses, 35 topics, 22 CLOs, prerequisites, and transitive downstream dependencies).
   - Traverses multi-hop dependency paths (e.g. `CSE 207 (Data Structures) ➔ CSE 301 (Algorithms) ➔ CSE 401 (AI) ➔ CSE 405 (Machine Learning)`).
2. **7 Core Impact Dimensions**:
   - **CLO Impact (Weight: 30%)**: Calculates before/after coverage drop (e.g. CLO-3 drops from 85% to 62%, -23% drop).
   - **Prerequisite Risk (Weight: 25%)**: Detects broken downstream conceptual foundations.
   - **Downstream Course Impact (Weight: 20%)**: Measures cascade severity through the university graph.
   - **Curriculum Knowledge Gaps (Weight: 10%)**: Flags untaught core competencies.
   - **Assessment Balance (Weight: 10%)**: Analyzes theory vs. practical lab hour shifts.
   - **Course Overlap & Placement (Weight: 5%)**: Analyzes redundancy and placement across semesters.
   - **Student Transition Readiness (7th Dimension)**: Predicts cohort academic friction when advancing to subsequent semesters.
3. **The "Why?" Evidence Layer**:
   - Interactive evidence inspector showing verified structural causal dependency paths (not LLM hallucinations) and citing IEEE/ACM CS2023 and ABET Criterion 3 accreditation standards.
4. **Interactive Academic Map with Ripple Effect**:
   - Interactive SVG node-link graph with pan, zoom, and node inspection.
   - Live simulation overlay featuring pulsing ripple animations across affected courses in Crimson, Amber, and Emerald.
5. **What-If Plan Alternatives**:
   - Evaluates **Plan A** (Proposed change), **Plan B** (Scope reduction), and **Plan C** (Curricular relocation) side-by-side and visually highlights the lowest-modeled impact option.
6. **Formal Printable Academic Impact Report**:
   - University-styled printable document (`window.print()`) featuring institution header, impact tables, committee remarks, and signature lines for Course Instructor, Head of Department, and Curriculum Committee Chair.
7. **Dual Engine (Gemini 2.5 + Local Heuristic Engine)**:
   - Resilient architecture: uses Google Gemini API when configured, and falls back to a deterministic academic simulation engine offline so the hackathon live demo **never fails**.

---

## 2. Project Structure (100% Pure Dart & Flutter)

```
e:\Acaddie_1.0\
├── package.json                 # Convenience scripts (flutter:run, flutter:analyze, etc.)
├── README.md                    # Project documentation & Quickstart
├── legacy_web_backup/           # Archived previous React/Node.js files
│   ├── client/                  # (Archived .jsx files)
│   └── server/                  # (Archived Node.js files)
└── acaddie_flutter/             # Active 100% Pure Flutter Application
    ├── pubspec.yaml             # Dependencies: google_fonts, shared_preferences
    └── lib/
        ├── main.dart            # App entry point, Shell, Auth Gate & Top Navigation
        ├── models/
        │   ├── curriculum_models.dart # Curriculum graph, CLO, courses & simulation models
        │   └── user_model.dart        # User authentication & profile data class
        ├── services/
        │   ├── academic_engine.dart   # Deterministic OBE graph simulation engine
        │   └── auth_service.dart      # Local persistent authentication service
        └── screens/
            ├── auth_screens.dart              # Login & Registration screens
            ├── course_catalog_screen.dart     # Course catalog with semester & search filters
            ├── simulation_history_screen.dart # Session simulation history & audit trail
            ├── simulation_studio_screen.dart  # Parameter configuration & simulation trigger
            ├── impact_report_screen.dart      # 7-dimension scorecards & evidence inspector
            ├── academic_map_screen.dart       # Interactive SVG/canvas course dependency graph
            └── what_if_screen.dart            # Multi-plan comparative analysis matrix
```
---

## 3. How to Run Locally (Flutter)

### Prerequisites
- Flutter SDK (3.x+) installed.

### Run Flutter Web
```bash
cd acaddie_flutter
flutter pub get
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```
Application will be live at: **`http://localhost:8080`**

---

## 4. Exact 2–3 Minute Judge Demo Flow

Follow these steps for the hackathon judging presentation:

1. **Open Landing Page**:
   - Point out the tagline: **“Think. Simulate. Decide.”**
   - Explain the core concept: *"Acaddie is like Google Maps for Academic Decisions. Don't change curriculum blindly. Simulate first."*
2. **Click `⚡ 1-Click Judge Demo` (or Scenario 1: Remove Graph Algorithms)**:
   - Target course: `CSE 207 Data Structures`.
   - Target action: `Remove Topic: Graph Algorithms (3.5 weeks)`.
3. **Observe the Multi-Stage AI Processing Animation**:
   - Shows real-time progression across the 7 academic dimensions.
4. **Inspect the Academic Change Impact Report**:
   - **Overall Score**: 76–78 / 100 (**HIGH RISK**).
   - **Confidence**: 98% (verified from graph connections).
   - **Executive Briefing**: Shows the 4-course cascade.
   - **Before vs After**: Shows 3.5 weeks lost, CLO-3 dropping from 85% to 62% (-23% drop).
5. **Click "Inspect 'Why?' Evidence"**:
   - Shows the exact causal dependency chain:
     `CSE 207 (Data Structures) ➔ Graph Algorithms ➔ CSE 301 (Algorithms) Topic: Shortest Paths ➔ CSE 401 (AI) Topic: State-Space Search`.
   - Highlights that this is structural graph evidence, not a hallucination.
6. **Click "Compare Plans"**:
   - Side-by-side comparison between:
     - **Plan A**: Full Deletion (78/100, High Risk)
     - **Plan B**: Scope Reduction (42/100, Medium Risk)
     - **Plan C**: Relocate to Algorithms (26/100, Low Risk — **Safest Option**).
7. **Click "View Ripple on Map"**:
   - Observe the interactive academic dependency graph where **Data Structures**, **Algorithms**, **AI**, and **Machine Learning** pulse with their respective risk colors.
8. **Click "Export Official Report"**:
   - Displays the printable official academic report with university header, OBE audit summary, and signature lines for Faculty, Dept Head, and Committee Chair.
9. **Deliver the Closing Pitch**:
   - *"Acaddie doesn't replace the faculty. It gives faculty the evidence to understand the consequences before making the decision."*
