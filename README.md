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

## 🛠️ Quick Start Guide

### 1. Prerequisites
- Node.js LTS (v24+ or v18+) installed.

### 2. Installation
```bash
# Install server and client dependencies
npm run install:all
```

### 3. Run the Application
In terminal 1:
```bash
npm run server
```
*Backend runs on `http://localhost:5001`*

In terminal 2:
```bash
npm run client
```
*Frontend opens at `http://127.0.0.1:5173`*

---

## 🎯 2-Minute Hackathon Judge Demo
1. Open `http://127.0.0.1:5173`.
2. Click **⚡ 1-Click Judge Demo** (Scenario 1: Remove Graph Algorithms).
3. Observe the multi-stage AI reasoning animation.
4. Review the **Overall Impact (78/100, HIGH RISK)**, CLO-3 reduction, and 4-course cascade.
5. Click **Inspect "Why?" Evidence** to view structural graph causal paths.
6. Click **Compare Plans** to see why Plan C (Move to Algorithms) is the safest alternative (26/100).
7. Click **View Ripple on Map** to see Data Structures, Algorithms, AI, and ML pulsing in real-time.
8. Click **Export Official Report** to inspect the printable accreditation document.

---

## 📄 License
Built for AUST CSE Carnival <8.0> AI Build Hackathon.