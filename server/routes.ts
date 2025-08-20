import type { Express } from "express";
import { createServer, type Server } from "http";
import { storage } from "./storage";
import { insertPatientSchema, insertChatMessageSchema } from "@shared/schema";
import { generatePatientData, generateChatResponse } from "./services/openai";
import { uploadPatientDataToAzure, testAzureConnection } from "./services/azure";

export async function registerRoutes(app: Express): Promise<Server> {
  
  // Test Azure connection
  app.get("/api/azure/status", async (req, res) => {
    try {
      const result = await testAzureConnection();
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: "Failed to test Azure connection" });
    }
  });

  // Generate patient data and submit to Azure
  app.post("/api/patients/generate-and-submit", async (req, res) => {
    try {
      // Step 1: Generate patient data using OpenAI
      const generatedData = await generatePatientData();
      
      // Step 2: Validate the generated data
      const validatedData = insertPatientSchema.parse(generatedData);
      
      // Step 3: Create patient record in storage
      const patient = await storage.createPatient(validatedData);
      
      // Step 4: Upload to Azure Blob Storage
      const azureResult = await uploadPatientDataToAzure(patient);
      
      if (!azureResult.success) {
        return res.status(500).json({ 
          error: azureResult.error,
          patient: patient 
        });
      }

      // Step 5: Update patient record with Azure URL
      const updatedPatient = await storage.updatePatientAzureUrl(patient.id, azureResult.blobUrl!);
      
      res.json({
        success: true,
        patient: updatedPatient,
        azureBlobUrl: azureResult.blobUrl,
        generatedData: validatedData
      });

    } catch (error) {
      console.error("Generate and submit error:", error);
      res.status(500).json({ 
        error: "Failed to generate and submit patient data: " + (error as Error).message 
      });
    }
  });

  // Get chat messages
  app.get("/api/chat/messages", async (req, res) => {
    try {
      const messages = await storage.getChatMessages();
      res.json(messages);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch chat messages" });
    }
  });

  // Send chat message and get AI response
  app.post("/api/chat/message", async (req, res) => {
    try {
      const { content } = req.body;
      
      if (!content || typeof content !== 'string') {
        return res.status(400).json({ error: "Message content is required" });
      }

      // Save user message
      const userMessage = await storage.createChatMessage({
        role: "user",
        content: content.trim()
      });

      // Generate AI response
      const aiResponseContent = await generateChatResponse(content);
      
      // Save AI response
      const aiMessage = await storage.createChatMessage({
        role: "assistant",
        content: aiResponseContent
      });

      res.json({
        userMessage,
        aiMessage
      });

    } catch (error) {
      console.error("Chat error:", error);
      res.status(500).json({ 
        error: "Failed to process chat message: " + (error as Error).message 
      });
    }
  });

  // Clear chat history
  app.delete("/api/chat/messages", async (req, res) => {
    try {
      await storage.clearChatMessages();
      res.json({ success: true });
    } catch (error) {
      res.status(500).json({ error: "Failed to clear chat messages" });
    }
  });

  const httpServer = createServer(app);
  return httpServer;
}
