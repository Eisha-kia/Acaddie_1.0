import React, { useState, useEffect } from "react";
import Navbar from "./components/Navbar.jsx";
import Sidebar from "./components/Sidebar.jsx";
import LandingHero from "./components/LandingHero.jsx";
import DashboardView from "./components/DashboardView.jsx";
import AcademicMap from "./components/AcademicMap.jsx";
import SimulationStudio from "./components/SimulationStudio.jsx";
import ImpactReportView from "./components/ImpactReportView.jsx";
import WhatIfComparison from "./components/WhatIfComparison.jsx";
import CourseCatalog from "./components/CourseCatalog.jsx";
import SimulationHistory from "./components/SimulationHistory.jsx";
import PrintableReport from "./components/PrintableReport.jsx";
import ProcessingAnimation from "./components/ProcessingAnimation.jsx";
import EvidenceModal from "./components/EvidenceModal.jsx";

import { 
  fetchHealth, 
  fetchCurriculum, 
  fetchHistory, 
  fetchSimulationById, 
  runSimulation, 
  updateFacultyDecision 
} from "./utils/api.js";

export default function App() {
  const [currentTab, setCurrentTab] = useState("landing");
  const [curriculum, setCurriculum] = useState(null);
  const [history, setHistory] = useState([]);
  const [engineStatus, setEngineStatus] = useState(null);
  const [activeSimulation, setActiveSimulation] = useState(null);
  const [pendingPayload, setPendingPayload] = useState(null);
  const [isProcessing, setIsProcessing] = useState(false);
  const [activeEvidence, setActiveEvidence] = useState(null);
  const [selectedCourseForStudio, setSelectedCourseForStudio] = useState(null);

  // Initialize data on mount
  useEffect(() => {
    async function loadInitialData() {
      try {
        const [healthData, currData, histData] = await Promise.all([
          fetchHealth().catch(() => null),
          fetchCurriculum().catch(() => null),
          fetchHistory().catch(() => [])
        ]);

        if (healthData) setEngineStatus(healthData);
        if (currData) setCurriculum(currData);
        if (histData) setHistory(histData);

        // Preload most recent simulation as active if exists
        if (histData && histData.length > 0) {
          const latest = await fetchSimulationById(histData[0].simulationId).catch(() => null);
          if (latest) setActiveSimulation(latest);
        }
      } catch (err) {
        console.error("Initialization error:", err);
      }
    }
    loadInitialData();
  }, []);

  // Handler for running simulation
  const handleStartSimulation = (payload) => {
    setPendingPayload(payload);
    setIsProcessing(true);
  };

  // Called when processing animation finishes
  const handleProcessingComplete = async () => {
    setIsProcessing(false);
    if (!pendingPayload) return;

    try {
      const result = await runSimulation(pendingPayload);
      setActiveSimulation(result);
      setCurrentTab("report");

      // Refresh history list
      const updatedHistory = await fetchHistory().catch(() => []);
      setHistory(updatedHistory);
    } catch (err) {
      alert(`Simulation Error: ${err.message}`);
    } finally {
      setPendingPayload(null);
    }
  };

  // 1-Click Judge Demo Scenarios
  const handleRunDemoScenario = (scenarioId) => {
    let payload;
    if (scenarioId === "scenario-1") {
      // Signature High-Risk Demo: Remove Graph Algorithms from Data Structures
      payload = {
        courseId: "CSE-207",
        action: "REMOVE_TOPIC",
        topicId: "DS-6",
        facultyReason: "Hackathon Judge Demo: Evaluating syllabus congestion by removing Graph Algorithms."
      };
    } else if (scenarioId === "scenario-2") {
      // Medium Risk: Shift Machine Learning assessment practicals
      payload = {
        courseId: "CSE-405",
        action: "CHANGE_ASSESSMENT",
        assessmentChanges: { practical: 25 },
        facultyReason: "Hackathon Judge Demo: Expanding hands-on project marks to 25%."
      };
    } else {
      // Low Risk: Add Python Programming to AI
      payload = {
        courseId: "CSE-401",
        action: "ADD_TOPIC",
        newTopicName: "Python Programming for Scientific Computing",
        newTopicWeeks: 2.0,
        facultyReason: "Hackathon Judge Demo: Adding Python script essentials for ML readiness."
      };
    }

    handleStartSimulation(payload);
  };

  // Handler for reopening a past simulation
  const handleReopenSimulation = async (simId) => {
    try {
      const data = await fetchSimulationById(simId);
      setActiveSimulation(data);
      setCurrentTab("report");
    } catch (err) {
      alert("Failed to load historical simulation.");
    }
  };

  // Handler for course selection to simulate
  const handleSimulateCourse = (courseId) => {
    setSelectedCourseForStudio(courseId);
    setCurrentTab("studio");
  };

  // Handler for saving faculty decisions
  const handleSaveFacultyDecision = async (simId, decision, notes) => {
    try {
      await updateFacultyDecision(simId, decision, notes);
      const updatedHistory = await fetchHistory().catch(() => []);
      setHistory(updatedHistory);
      if (activeSimulation && activeSimulation.simulationId === simId) {
        setActiveSimulation(prev => ({
          ...prev,
          facultyControl: { ...prev.facultyControl, status: decision, notes }
        }));
      }
    } catch (err) {
      alert("Failed to save faculty decision.");
    }
  };

  return (
    <div className="app-container">
      {/* Sidebar Navigation (Hidden in Printable view) */}
      {currentTab !== "printable" && (
        <Sidebar 
          currentTab={currentTab} 
          setCurrentTab={setCurrentTab} 
          activeSimulation={activeSimulation}
        />
      )}

      {/* Main Content Area */}
      <div className="main-content">
        {/* Navbar (Hidden in Printable view) */}
        {currentTab !== "printable" && (
          <Navbar 
            currentTab={currentTab}
            setCurrentTab={setCurrentTab}
            engineStatus={engineStatus}
            onRunDemoScenario={handleRunDemoScenario}
          />
        )}

        {/* Page Content Container */}
        <main className="page-wrapper">
          {currentTab === "landing" && (
            <LandingHero 
              onStartSimulation={() => setCurrentTab("studio")}
              onExploreMap={() => setCurrentTab("map")}
              onRunDemo={handleRunDemoScenario}
            />
          )}

          {currentTab === "dashboard" && (
            <DashboardView 
              curriculum={curriculum}
              history={history}
              activeSimulation={activeSimulation}
              onNewSimulation={() => setCurrentTab("studio")}
              onOpenMap={() => setCurrentTab("map")}
              onRunDemoScenario={handleRunDemoScenario}
              onReopenSimulation={handleReopenSimulation}
            />
          )}

          {currentTab === "map" && (
            <AcademicMap 
              curriculum={curriculum}
              activeSimulation={activeSimulation}
              onSimulateCourse={handleSimulateCourse}
              onOpenEvidence={(ev) => setActiveEvidence(ev)}
            />
          )}

          {currentTab === "studio" && (
            <SimulationStudio 
              curriculum={curriculum}
              initialCourseId={selectedCourseForStudio}
              onRunSimulation={handleStartSimulation}
            />
          )}

          {currentTab === "report" && (
            <ImpactReportView 
              simulation={activeSimulation}
              onViewOnMap={() => setCurrentTab("map")}
              onComparePlans={() => setCurrentTab("comparison")}
              onExportReport={() => setCurrentTab("printable")}
              onOpenEvidence={(ev) => setActiveEvidence(ev)}
              onSaveFacultyDecision={handleSaveFacultyDecision}
            />
          )}

          {currentTab === "comparison" && (
            <WhatIfComparison 
              simulation={activeSimulation}
              onViewOnMap={() => setCurrentTab("map")}
              onExportReport={() => setCurrentTab("printable")}
            />
          )}

          {currentTab === "courses" && (
            <CourseCatalog 
              curriculum={curriculum}
              onSimulateCourse={handleSimulateCourse}
            />
          )}

          {currentTab === "history" && (
            <SimulationHistory 
              history={history}
              onReopenSimulation={handleReopenSimulation}
            />
          )}

          {currentTab === "printable" && (
            <PrintableReport 
              simulation={activeSimulation}
              onBack={() => setCurrentTab("report")}
            />
          )}
        </main>
      </div>

      {/* Multi-step AI Processing Animation Modal */}
      {isProcessing && (
        <ProcessingAnimation onComplete={handleProcessingComplete} />
      )}

      {/* "Why?" Evidence Modal */}
      {activeEvidence && (
        <EvidenceModal 
          evidence={activeEvidence} 
          onClose={() => setActiveEvidence(null)} 
        />
      )}
    </div>
  );
}
