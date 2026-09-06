const API_BASE = "/api";

export async function fetchHealth() {
  const res = await fetch(`${API_BASE}/health`);
  if (!res.ok) throw new Error("Health check failed");
  return res.json();
}

export async function fetchCurriculum() {
  const res = await fetch(`${API_BASE}/curriculum`);
  if (!res.ok) throw new Error("Failed to load curriculum");
  return res.json();
}

export async function fetchDemoScenarios() {
  const res = await fetch(`${API_BASE}/demo-scenarios`);
  if (!res.ok) throw new Error("Failed to load demo scenarios");
  return res.json();
}

export async function runSimulation(payload) {
  const res = await fetch(`${API_BASE}/simulate`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
  if (!res.ok) {
    const errorData = await res.json().catch(() => ({}));
    throw new Error(errorData.message || "Simulation failed");
  }
  return res.json();
}

export async function fetchHistory() {
  const res = await fetch(`${API_BASE}/history`);
  if (!res.ok) throw new Error("Failed to load history");
  return res.json();
}

export async function fetchSimulationById(id) {
  const res = await fetch(`${API_BASE}/history/${id}`);
  if (!res.ok) throw new Error("Failed to load simulation detail");
  return res.json();
}

export async function updateFacultyDecision(id, decision, notes) {
  const res = await fetch(`${API_BASE}/history/${id}/decision`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ decision, notes })
  });
  if (!res.ok) throw new Error("Failed to update faculty decision");
  return res.json();
}
