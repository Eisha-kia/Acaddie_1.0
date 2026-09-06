import dotenv from "dotenv";
dotenv.config();

/**
 * Gemini AI Reasoning Service
 * Enhances simulation results with rich academic commentary when GEMINI_API_KEY is present.
 * Transparently falls back to local academic heuristics if API key is absent or offline.
 */
export class GeminiService {
  static hasApiKey() {
    return Boolean(process.env.GEMINI_API_KEY && process.env.GEMINI_API_KEY.trim() !== "");
  }

  static async enrichSimulation(simulationData) {
    if (!this.hasApiKey()) {
      return {
        isAiEnriched: false,
        engineMode: "LOCAL_DETERMINISTIC_ENGINE",
        engineBadge: "Local Academic Simulation Engine (Deterministic)",
        aiNotes: "Running in zero-latency deterministic academic modeling mode. Graph analysis, CLO mappings, and scores are mathematically verified."
      };
    }

    try {
      // Use standard fetch to call Google Generative Language API
      const apiKey = process.env.GEMINI_API_KEY.trim();
      const endpoint = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${apiKey}`;

      const prompt = `You are ACADDIE, an AI Academic Decision Assistant for university faculty.
Analyze the following curriculum modification simulation result and provide concise, rigorous academic commentary:
Course: ${simulationData.course.code} - ${simulationData.course.name}
Action: ${simulationData.action}
Target: ${simulationData.topic ? simulationData.topic.name : "Assessment Modification"}
Impact Score: ${simulationData.overallScore}/100 (${simulationData.riskLevel})
Affected Downstream Courses: ${simulationData.downstreamImpact.map(d => d.courseCode).join(", ")}

Respond with a JSON object strictly matching this schema:
{
  "academicInsight": "Concise 2-sentence summary of the pedagogical risk or opportunity",
  "facultyGuidance": "One actionable recommendation for the faculty member/curriculum committee",
  "longTermCurriculumImpact": "Assessment of student career or graduate study readiness"
}`;

      const response = await fetch(endpoint, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: { responseMimeType: "application/json" }
        })
      });

      if (!response.ok) {
        throw new Error(`Gemini API returned status ${response.status}`);
      }

      const result = await response.json();
      const rawText = result.candidates?.[0]?.content?.parts?.[0]?.text;
      const parsed = JSON.parse(rawText);

      return {
        isAiEnriched: true,
        engineMode: "GEMINI_AI_REASONING_ENGINE",
        engineBadge: "Google Gemini 2.5 Flash + Deterministic Graph",
        aiInsight: parsed.academicInsight,
        aiGuidance: parsed.facultyGuidance,
        longTermImpact: parsed.longTermCurriculumImpact
      };
    } catch (err) {
      console.warn("Gemini enrichment fallback triggered:", err.message);
      return {
        isAiEnriched: false,
        engineMode: "LOCAL_DETERMINISTIC_ENGINE",
        engineBadge: "Local Academic Simulation Engine (Deterministic Fallback)",
        aiNotes: "Offline academic graph model applied. All impact matrices and causal chains are locally verified."
      };
    }
  }
}
