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

## 2. Project Structure

```
e:\Acaddie_1.0\
├── package.json                 # Monorepo scripts (server, client, build)
├── .env.example                 # Environment variables (PORT=5001, GEMINI_API_KEY)
├── server/
│   ├── package.json
│   ├── index.js                 # Express server on port 5001
│   ├── data/
│   │   ├── curriculum.js        # 7-course CSE dataset (topics, CLOs, prerequisites, assessments)
│   │   └── history.json         # Persistent simulation history
│   └── services/
│       ├── graphEngine.js       # Directed graph BFS/DFS traversal & path solver
│       ├── simulationEngine.js  # 7-dimension deterministic impact simulator
│       ├── scoringEngine.js     # Explainable weighted regression (0-100)
│       ├── evidenceEngine.js    # "Why?" causal chain builder with structural proofs
│       ├── alternativesEngine.js# Automated Plan A, Plan B, Plan C generator
│       ├── geminiService.js     # Optional Gemini 2.5 Flash API with local fallback
│       └── historyStore.js      # Persistent history store
└── client/
    ├── package.json
    ├── vite.config.js           # Vite config with API proxy to port 5001
    ├── index.html
    └── src/
        ├── index.css            # Custom SaaS styling system (Navy, Slate, Gold, Emerald, Crimson)
        ├── main.jsx             # React DOM entrypoint
        ├── App.jsx              # Master application controller & state management
        ├── utils/
        │   └── api.js           # API communication utility
        └── components/
            ├── Navbar.jsx               # Header, engine badge, 1-click Judge Demo dropdown
            ├── Sidebar.jsx              # Navigation (Dashboard, Map, Studio, Courses, History, Report)
            ├── LandingHero.jsx          # "Think. Simulate. Decide." hero view
            ├── DashboardView.jsx        # Academic Decision Center stats & quick scenarios
            ├── AcademicMap.jsx          # Interactive SVG dependency graph & ripple pulses
            ├── SimulationStudio.jsx     # 9-action change configuration wizard
            ├── ProcessingAnimation.jsx  # Multi-stage AI checkmark progression
            ├── ImpactReportView.jsx     # 7-dimension breakdown, score gauge, faculty control
            ├── WhatIfComparison.jsx     # Side-by-side Plan A vs B vs C comparison matrix
            ├── CourseCatalog.jsx        # Course syllabi, topics, and CLO inspector
            ├── SimulationHistory.jsx    # Historical simulation audit trail
            ├── PrintableReport.jsx      # University committee sign-off document
            └── EvidenceModal.jsx        # Structural "Why?" causal path modal
```

---

## 3. How to Run Locally

### Prerequisites
- Node.js LTS (v24+ or v18+) installed.

### Start Backend and Frontend
1. Open a terminal in `e:\Acaddie_1.0`:
   ```bash
   # Start backend API server (runs on http://localhost:5001)
   npm run server
   ```
2. In a second terminal in `e:\Acaddie_1.0`:
   ```bash
   # Start frontend client (runs on http://127.0.0.1:5173)
   npm run client
   ```
3. Open your browser and navigate to: **`http://127.0.0.1:5173`**

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
