import { sql } from "drizzle-orm";
import { pgTable, text, varchar, timestamp } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod";

export const patients = pgTable("patients", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  fullName: text("full_name").notNull(),
  email: text("email").notNull(),
  birthday: text("birthday").notNull(),
  ssn: text("ssn").notNull(),
  creditCard: text("credit_card").notNull(),
  expiryDate: text("expiry_date").notNull(),
  cvv: text("cvv").notNull(),
  azureBlobUrl: text("azure_blob_url"),
  createdAt: timestamp("created_at").defaultNow(),
});

export const chatMessages = pgTable("chat_messages", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  role: text("role").notNull(),
  content: text("content").notNull(),
  timestamp: timestamp("timestamp").defaultNow(),
});

export const insertPatientSchema = createInsertSchema(patients).omit({
  id: true,
  azureBlobUrl: true,
  createdAt: true,
});

export const insertChatMessageSchema = createInsertSchema(chatMessages).omit({
  id: true,
  timestamp: true,
});

export type InsertPatient = z.infer<typeof insertPatientSchema>;
export type Patient = typeof patients.$inferSelect;
export type InsertChatMessage = z.infer<typeof insertChatMessageSchema>;
export type ChatMessage = typeof chatMessages.$inferSelect;

// Form generation response schema
export const generatedDataSchema = z.object({
  fullName: z.string(),
  email: z.string().email(),
  birthday: z.string(),
  ssn: z.string(),
  creditCard: z.string(),
  expiryDate: z.string(),
  cvv: z.string(),
});

export type GeneratedData = z.infer<typeof generatedDataSchema>;
