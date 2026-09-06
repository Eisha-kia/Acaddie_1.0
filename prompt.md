# 🎓 ACADDIE 1.0 — MASTER BLUEPRINT PROMPT
> **"Think. Simulate. Decide."**  
> *Google Maps for Academic Decisions — Don't change curriculum blindly. Simulate first.*

---

## 📌 PROMPT OVERVIEW
This prompt is designed to be fed directly into an advanced AI coding assistant (e.g., Gemini, Claude, GPT-4) to generate the complete **ACADDIE** academic change impact simulator platform from scratch.

```markdown
You are an expert full-stack developer and university curriculum system architect.
Build a production-grade, state-of-the-art web application named **"ACADDIE 1.0"**.

### Tagline & Core Philosophy:
- Tagline: "Think. Simulate. Decide."
- Philosophy: "Google Maps for Academic Decisions. Don't change curriculum blindly. Simulate first."
- Purpose: A decision-support simulator for university faculty members, department heads, and curriculum committees (modeled for Ahsanullah University of Science and Technology - AUST CSE department) under Outcome-Based Education (OBE) accreditation standards (ABET & IEEE/ACM CS2023).

---

## 1. 🎨 DESIGN SYSTEM & TYPOGRAPHY SPECIFICATIONS

1. **Typography**:
   - **Headings**: `Cormorant Garamond` (SemiBold / 600 weight) for all section headers, hero titles, modal titles, and card headers.
   - **Body & Controls**: `Inter` (or Arial / Helvetica fallback) for body text, inputs, buttons, tables, badges, and captions.
2. **Dual-Theme Engine (Dark & Light Mode)**:
   - Provide a persistent toggle button in the top navigation bar and sidebar to switch seamlessly between Dark Mode and Light Mode.
   - **Dark Mode Palette**:
     - Background: `#060D1A` (Deep Midnight Blue)
     - Surface / Panels: `#0F172A` (Dark Slate)
     - Card / Container: `#1E293B` (Navy Slate)
     - Primary Accent: `#0284C7` (Electric Sky Blue)
     - Secondary Accent: `#38BDF8` (Cyan Neon)
     - High Risk: `#EF4444` (Crimson)
     - Moderate Risk: `#F59E0B` (Amber)
     - Safe / Low Risk: `#10B981` (Emerald)
   - **Light Mode Palette**:
     - Background: `#F8FAFC` (Academic Paper Off-White)
     - Surface / Panels: `#FFFFFF` (Pure White)
     - Card / Container: `#F1F5F9` (Light Slate Gray)
     - Borders: `#E2E8F0`
     - Text Primary: `#0F172A` (Charcoal)
     - Text Secondary: `#475569` (Muted Slate)
3. **Language**:
   - 100% professional academic English throughout all user interfaces, tooltips, validation messages, and reports.
4. **Branding & Logo**:
   - An academic emblem featuring a deep-blue/electric-cyan gradient rounded shield containing an academic book glyph intertwined with interconnected AI neural nodes.
   - Display "ACADDIE 1.0 — Academic Impact Simulator".

---

## 2. 🧠 CORE ACADEMIC DATASET (AUST CSE OBE STANDARD)

Pre-load the system with the 7 core sequential computer science courses:

1. **`CSE-101` Structured Programming Language (C)** — Sem 1, 3.0 Cr.
   - Topics: Variables & Expressions (2w), Control Structures & Loops (3w), Arrays & Strings (3w), Functions & Recursion (3w), Pointers & Dynamic Memory (3w).
   - CLOs: CLO-1 [K3 - Apply: Synthesize structured C code], CLO-2 [K4 - Analyze: Memory allocation].
2. **`CSE-207` Data Structures** — Sem 3, 3.0 Cr. (Prerequisite: CSE-101)
   - Topics: Arrays & Linked Lists (2.5w), Stacks & Queues (2w), Trees & BSTs (3w), Heaps & Priority Queues (2w), Hashing Techniques (2w), Graph Representations & Traversal (BFS/DFS) (3.5w).
   - CLOs: CLO-1 [K3: Implement linear data structures], CLO-2 [K4: Analyze asymptotic complexity], CLO-3 [K4: Graph traversals & connectivity proofs].
3. **`CSE-301` Algorithms** — Sem 4, 3.0 Cr. (Prerequisite: CSE-207)
   - Topics: Divide & Conquer (2.5w), Greedy Algorithms (2.5w), Dynamic Programming (3.5w), Graph Shortest Paths (Dijkstra/Bellman-Ford) (3w), NP-Completeness (2.5w).
   - CLOs: CLO-1 [K4: Algorithm design paradigms], CLO-2 [K4: Optimal substructure proofs], CLO-3 [K5 - Evaluate: Intractability].
4. **`CSE-305` Database Management Systems** — Sem 5, 3.0 Cr. (Prerequisite: CSE-207)
   - Topics: Relational Model & SQL (3w), B-Tree Indexing (2.5w), Normalization (3w), Transaction ACID (3w), Distributed DBs (2.5w).
5. **`CSE-307` Operating Systems** — Sem 5, 3.0 Cr. (Prerequisite: CSE-207)
   - Topics: Process Management (3w), Deadlock Avoidance (2.5w), Virtual Memory (3.5w), File Systems (2.5w), Security (2.5w).
6. **`CSE-401` Artificial Intelligence** — Sem 6, 3.0 Cr. (Prerequisite: CSE-301)
   - Topics: State Space Search (A*, Minimax) (3w), Knowledge Representation & Logic (3w), Probabilistic Reasoning (3w), Machine Learning Foundations (3w), Computer Vision Basics (2w).
7. **`CSE-405` Machine Learning & Deep Learning** — Sem 7, 3.0 Cr. (Prerequisites: CSE-301, CSE-401)
   - Topics: Supervised Learning (3w), Unsupervised Clustering (2w), Neural Networks & Backpropagation (3.5w), Transformers & LLMs (3.5w), Reinforcement Learning (2w).

---

## 3. 🔬 THE 7-DIMENSION AI SIMULATION ENGINE

When a user proposes modifying a course (e.g. Removing a topic, reducing duration, changing assessment weights), calculate the downstream ripple effects across the entire curriculum DAG:

1. **Dimension 1: CLO Attainment Impact (Weight: 30%)**:
   - Calculates the drop in Course Learning Outcome coverage (e.g., CLO-3 drops from 85% to 62%, a -23% reduction).
2. **Dimension 2: Prerequisite Risk (Weight: 25%)**:
   - Identifies broken foundational prerequisites in subsequent courses (e.g., Removing BFS/DFS from CSE-207 leaves CSE-301, CSE-401, and CSE-405 students unprepared for Graph Algorithms and Neural Graphs).
3. **Dimension 3: Downstream Course Impact (Weight: 20%)**:
   - Graph BFS traversal measuring multi-hop cascade depth and severity across subsequent semesters.
4. **Dimension 4: Curriculum Gap Detection (Weight: 10%)**:
   - Checks against international computing standards (IEEE/ACM CS2023 & ABET Criterion 3) to identify untaught core competencies.
5. **Dimension 5: Assessment Balance (Weight: 10%)**:
   - Tracks shifts between theoretical exams and practical lab evaluations.
6. **Dimension 6: Course Overlap & Placement (Weight: 5%)**:
   - Detects redundancies or improper semester placement.
7. **Dimension 7: Student Transition Readiness**:
   - Predicts cohort academic friction score when students advance to downstream terms.

**Overall Impact Formula**:
$$\text{Score} = \sum (\text{Dimension Score} \times \text{Weight}) \in [0, 100]$$
- **High Risk**: Score 70–100 (Red badge, warning alert, committee review required)
- **Medium Risk**: Score 40–69 (Amber badge, advisory warning)
- **Low Risk**: Score 0–39 (Green badge, safe to implement)

---

## 4. 🧭 APPLICATION ARCHITECTURE & VIEWS

1. **Authentication & Faculty Profile**:
   - Persistent login / register screen storing: Full Name, University Email, Phone, Password, University Name, Faculty ID, Department Address.
   - Auto-login if session already exists; Logout button in sidebar.
2. **Academic Decision Center (Dashboard)**:
   - Hero banner with Cormorant Garamond title: *"Think. Simulate. Decide."*
   - Real-time stat cards: Total Courses, Curricular Dependencies, Active Risk Level, Engine Health.
   - **1-Click Judge Demo Button** (`⚡ 1-Click Judge Demo`): Instantly simulates Scenario 1 (Removing Graph Algorithms from CSE-207).
   - Quick Preset Cards:
     - Preset 1: *Remove Graph Algorithms (CSE-207)* — High Risk (78/100).
     - Preset 2: *Shift Assessment to 25% Practical (CSE-405)* — Low Risk (18/100).
     - Preset 3: *Add Python for Scientific Computing (CSE-401)* — Low Risk (14/100).
3. **Simulation Studio**:
   - Form controls to select Target Course, Action Type (`REMOVE_TOPIC`, `ADD_TOPIC`, `CHANGE_ASSESSMENT`, `REDUCE_COVERAGE`), Specific Topic, Duration Weeks slider, and Faculty Rationale.
   - "Run AI Simulation" button with animated reasoning overlay.
4. **Impact Report View**:
   - Large Impact Gauge (e.g. 78/100 High Risk).
   - Detailed dimension breakdown cards with progress bars and before/after values.
   - **"Why?" Evidence Chain Modal**: Shows structural graph proofs connecting the modified topic directly to downstream courses and ABET/IEEE standards.
   - Direct buttons to "View on Map", "Compare Plans", and "Export Official Report".
5. **Interactive Academic Map**:
   - Node-link canvas/SVG diagram showing course prerequisite relationships (`CSE-101 ➔ CSE-207 ➔ CSE-301 ➔ CSE-401 ➔ CSE-405`).
   - When a simulation is active, affected course nodes pulse with animated ripples in real-time.
6. **What-If Multi-Plan Matrix**:
   - Side-by-side comparative cards:
     - **Plan A (Proposed)**: Direct change (e.g., Remove topic completely).
     - **Plan B (Scope Reduction)**: Retain core foundations with reduced weeks.
     - **Plan C (Curricular Relocation)**: Safest alternative — moves the topic to the appropriate downstream course.
7. **Department Course Catalog**:
   - Real-time search bar (by course code or title).
   - Semester filter dropdown (`All Semesters`, `Sem 1`, `Sem 3`, `Sem 4`, `Sem 5`, `Sem 6`, `Sem 7`).
   - Expandable course cards displaying: Credit units, syllabus topics with weeks, and CLOs with Bloom's Taxonomy ratings (`[K3 - Apply]`, `[K4 - Analyze]`, etc.).
   - Instant "Simulate Change" button on each course.
8. **Simulation History**:
   - Session audit trail recording all executed simulations with timestamps, course names, and risk verdicts.
9. **Printable Accreditation Report**:
   - Formal university header, change rationale, impact scores, and signature lines for Course Instructor, Department Head, and Curriculum Committee Chair.

---

## 5. 🚀 TECHNICAL STACK REQUIREMENT
- **Language & Framework**: Flutter 3.x (Web, Windows, Desktop & Mobile responsive).
- **Architecture**: Clean modular Dart files:
  - `models/`: `curriculum_models.dart`, `user_model.dart`
  - `services/`: `academic_engine.dart` (offline deterministic engine), `theme_service.dart` (Dark/Light notifier), `auth_service.dart`, `firebase_backend_service.dart`
  - `screens/`: `auth_screens.dart`, `dashboard_screen.dart`, `course_catalog_screen.dart`, `simulation_studio_screen.dart`, `impact_report_screen.dart`, `academic_map_screen.dart`, `what_if_screen.dart`, `simulation_history_screen.dart`
  - `widgets/`: `acaddie_logo.dart`
- **Dependencies**: `google_fonts`, `shared_preferences`, `firebase_core`, `firebase_auth`.
```
