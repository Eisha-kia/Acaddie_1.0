# ACADDIE 1.0

### AI-Powered Academic Change Impact Simulator
> **“Think. Simulate. Decide.”**  
> *Google Maps for Academic Decisions — Don't change blindly. Simulate first.*

---

## 🏆 Project Overview
**ACADDIE** is an AI-powered academic decision-support platform designed for university faculty members and curriculum committees participating in the **AUST CSE Carnival <8.0> — AI Build Hackathon**.

When a faculty member proposes modifying a course or syllabus (e.g. removing a topic, adjusting coverage, or altering assessment weights), Acaddie simulates the downstream ripple effects across the entire curriculum graph before the change is implemented.

---

## 🚀 Key Features

1. **7 Core Impact Dimensions**:
   - **CLO Impact (30% weight)**: Calculates attainment drop per Course Learning Outcome (e.g., CLO-3 drops from 85% to 62%).
   - **Prerequisite Risk (25% weight)**: Detects broken foundational readiness for downstream courses.
   - **Downstream Course Cascade (20% weight)**: Multi-hop graph traversal (e.g., `Data Structures ➔ Algorithms ➔ AI ➔ ML`).
   - **Curriculum Gap Detection (10% weight)**: Identifies essential competencies omitted from the 4-year degree.
   - **Assessment Balance (10% weight)**: Analyzes theoretical examination vs. practical laboratory shifts.
   - **Course Overlap & Placement (5% weight)**: Detects redundant or misplaced topics across semesters.
   - **Student Transition Readiness (7th Dimension)**: Predicts cohort academic friction advancing to subsequent terms.

2. **The "Why?" Evidence Layer**:
   - Verifiable causal dependency paths connecting source topics to downstream courses and ABET/IEEE CS2023 accreditation standards.

3. **Interactive Academic Map with Ripple Effect**:
   - Interactive SVG dependency graph featuring real-time pulse animations across affected course nodes.

4. **What-If Plan Comparison**:
   - Side-by-side comparison between **Plan A (Proposed)**, **Plan B (Scope Reduction)**, and **Plan C (Curricular Relocation)**, highlighting the safest option.

5. **Dual Engine Architecture**:
   - Google Gemini 2.5 Flash LLM reasoning layer + resilient local deterministic simulation engine that never fails offline during live hackathon judging.

6. **Official Printable Academic Impact Report**:
   - Ready for departmental committee sign-off with official university headers and signature lines.

---

## 📱 Technology Stack
- **Framework**: **Flutter 3.x (Dart)** (Web & Cross-Platform)
- **State Management & Persistence**: SharedPreferences (local session & auth storage)
- **Typography & Styling**: Google Fonts (Inter), Custom Dark Slate Academic Design System

---

## 🛠️ Quick Start Guide (Flutter)

### 1. Prerequisites
- **Flutter SDK (3.x+)** installed.

### 2. Run the Flutter Web App
```bash
cd acaddie_flutter
flutter pub get
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```
*The app is live and available at:* **`http://localhost:8080`**

---

## 🎯 2-Minute Hackathon Judge Demo
1. Open **`http://localhost:8080`** in your browser.
2. If first time: Create an account via **Register** (Name, Email, Phone, Password, Varsity name, ID, Address).
3. On the Dashboard, click **⚡ 1-Click Judge Demo (Remove Graph Algorithms)**.
4. Review the **Overall Impact (78/100, HIGH RISK)**, CLO-3 reduction, and downstream course cascade.
5. Click **Inspect "Why?" Evidence** to view structural graph causal paths and ABET/IEEE CS2023 alignment.
6. Check **Academic Map** to see animated nodes pulsing in real-time.
7. Click **What-If Matrix** to compare Plan A, Plan B, and Plan C.
8. Click **Course Catalog** to inspect all courses, syllabi topics, and CLOs.
9. Click **Export Official Report** to inspect the printable accreditation document.

---

## 📁 Architecture (100% Pure Dart & Flutter)
```
acaddie_flutter/lib/
├── main.dart                          # App entry point, Shell & Top Navigation
├── models/
│   ├── curriculum_models.dart         # Curriculum graph, CLO, courses & simulation models
│   └── user_model.dart                # User authentication & profile data class
├── services/
│   ├── academic_engine.dart           # Deterministic OBE graph simulation engine
│   └── auth_service.dart              # Local persistent authentication service
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

## 📄 License
Built for AUST CSE Carnival <8.0> AI Build Hackathon.