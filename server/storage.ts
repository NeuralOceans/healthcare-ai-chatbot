import { type Patient, type InsertPatient, type ChatMessage, type InsertChatMessage } from "@shared/schema";
import { randomUUID } from "crypto";

export interface IStorage {
  // Patient operations
  createPatient(patient: InsertPatient): Promise<Patient>;
  getPatient(id: string): Promise<Patient | undefined>;
  updatePatientAzureUrl(id: string, azureBlobUrl: string): Promise<Patient | undefined>;

  // Chat operations
  createChatMessage(message: InsertChatMessage): Promise<ChatMessage>;
  getChatMessages(): Promise<ChatMessage[]>;
  clearChatMessages(): Promise<void>;
}

export class MemStorage implements IStorage {
  private patients: Map<string, Patient>;
  private chatMessages: Map<string, ChatMessage>;

  constructor() {
    this.patients = new Map();
    this.chatMessages = new Map();
    
    // Add initial AI greeting message
    const initialMessage: ChatMessage = {
      id: randomUUID(),
      role: "assistant",
      content: "Hello! I'm your healthcare AI assistant. I can help you fill out the patient information form with sample data for testing purposes. Just click the 'Generate' button when you're ready, and I'll populate all the required fields instantly.",
      timestamp: new Date(),
    };
    this.chatMessages.set(initialMessage.id, initialMessage);
  }

  async createPatient(insertPatient: InsertPatient): Promise<Patient> {
    const id = randomUUID();
    const patient: Patient = { 
      ...insertPatient, 
      id, 
      azureBlobUrl: null,
      createdAt: new Date(),
    };
    this.patients.set(id, patient);
    return patient;
  }

  async getPatient(id: string): Promise<Patient | undefined> {
    return this.patients.get(id);
  }

  async updatePatientAzureUrl(id: string, azureBlobUrl: string): Promise<Patient | undefined> {
    const patient = this.patients.get(id);
    if (patient) {
      patient.azureBlobUrl = azureBlobUrl;
      this.patients.set(id, patient);
      return patient;
    }
    return undefined;
  }

  async createChatMessage(insertMessage: InsertChatMessage): Promise<ChatMessage> {
    const id = randomUUID();
    const message: ChatMessage = {
      ...insertMessage,
      id,
      timestamp: new Date(),
    };
    this.chatMessages.set(id, message);
    return message;
  }

  async getChatMessages(): Promise<ChatMessage[]> {
    return Array.from(this.chatMessages.values()).sort((a, b) => 
      a.timestamp!.getTime() - b.timestamp!.getTime()
    );
  }

  async clearChatMessages(): Promise<void> {
    this.chatMessages.clear();
  }
}

export const storage = new MemStorage();
