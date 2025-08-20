import OpenAI from "openai";
import { type GeneratedData } from "@shared/schema";

// the newest OpenAI model is "gpt-4o" which was released May 13, 2024. do not change this unless explicitly requested by the user
const openai = new OpenAI({ 
  apiKey: process.env.OPENAI_API_KEY || process.env.VITE_OPENAI_API_KEY || "your-openai-api-key" 
});

export async function generatePatientData(): Promise<GeneratedData> {
  try {
    const response = await openai.chat.completions.create({
      model: "gpt-4o",
      messages: [
        {
          role: "system",
          content: "You are a healthcare data generator. Generate realistic but fictional patient data for testing purposes. Ensure all data is properly formatted and realistic. Respond with JSON in this exact format: { 'fullName': string, 'email': string, 'birthday': string (YYYY-MM-DD), 'ssn': string (XXX-XX-XXXX), 'creditCard': string (XXXX XXXX XXXX XXXX), 'expiryDate': string (MM/YY), 'cvv': string (3-4 digits) }",
        },
        {
          role: "user",
          content: "Generate realistic patient form data with proper formatting for healthcare testing purposes.",
        },
      ],
      response_format: { type: "json_object" },
    });

    const result = JSON.parse(response.choices[0].message.content || "{}");
    
    // Validate the response has all required fields
    const requiredFields = ['fullName', 'email', 'birthday', 'ssn', 'creditCard', 'expiryDate', 'cvv'];
    for (const field of requiredFields) {
      if (!result[field]) {
        throw new Error(`Missing required field: ${field}`);
      }
    }

    return result;
  } catch (error) {
    throw new Error("Failed to generate patient data: " + (error as Error).message);
  }
}

export async function generateChatResponse(userMessage: string, context: string = ""): Promise<string> {
  try {
    const response = await openai.chat.completions.create({
      model: "gpt-4o",
      messages: [
        {
          role: "system",
          content: "You are a helpful healthcare AI assistant. You help users with patient form data generation and Azure blob storage operations. Be professional, concise, and helpful. Focus on healthcare data management tasks.",
        },
        {
          role: "user",
          content: `Context: ${context}\n\nUser message: ${userMessage}`,
        },
      ],
    });

    return response.choices[0].message.content || "I'm sorry, I couldn't generate a response at this time.";
  } catch (error) {
    throw new Error("Failed to generate chat response: " + (error as Error).message);
  }
}
