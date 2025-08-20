import { BlobServiceClient, StorageSharedKeyCredential } from "@azure/storage-blob";
import { type Patient } from "@shared/schema";

const accountName = process.env.AZURE_STORAGE_ACCOUNT_NAME || process.env.VITE_AZURE_STORAGE_ACCOUNT_NAME || "your-storage-account";
const accountKey = process.env.AZURE_STORAGE_ACCOUNT_KEY || process.env.VITE_AZURE_STORAGE_ACCOUNT_KEY || "your-storage-key";
const containerName = process.env.AZURE_CONTAINER_NAME || process.env.VITE_AZURE_CONTAINER_NAME || "patient-data";

let blobServiceClient: BlobServiceClient;

try {
  const sharedKeyCredential = new StorageSharedKeyCredential(accountName, accountKey);
  blobServiceClient = new BlobServiceClient(
    `https://${accountName}.blob.core.windows.net`,
    sharedKeyCredential
  );
} catch (error) {
  console.error("Failed to initialize Azure Blob Service Client:", error);
}

export interface AzureUploadResult {
  success: boolean;
  blobUrl?: string;
  error?: string;
}

export async function uploadPatientDataToAzure(patient: Patient): Promise<AzureUploadResult> {
  try {
    if (!blobServiceClient) {
      throw new Error("Azure Blob Service Client not initialized. Check your Azure credentials.");
    }

    const containerClient = blobServiceClient.getContainerClient(containerName);
    
    // Ensure container exists
    try {
      await containerClient.createIfNotExists();
    } catch (containerError) {
      console.warn("Container creation warning:", containerError);
    }

    // Create blob name with timestamp
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const blobName = `patient-${patient.id}-${timestamp}.json`;
    
    const blockBlobClient = containerClient.getBlockBlobClient(blobName);

    // Prepare patient data for upload (excluding sensitive credit card info in logs)
    const uploadData = {
      id: patient.id,
      fullName: patient.fullName,
      email: patient.email,
      birthday: patient.birthday,
      ssn: patient.ssn,
      creditCard: patient.creditCard, // In production, this would be encrypted/tokenized
      expiryDate: patient.expiryDate,
      cvv: patient.cvv,
      createdAt: patient.createdAt,
      uploadedAt: new Date().toISOString(),
    };

    // Upload the patient data as JSON
    const dataString = JSON.stringify(uploadData, null, 2);
    await blockBlobClient.upload(dataString, dataString.length, {
      blobHTTPHeaders: {
        blobContentType: "application/json",
      },
      metadata: {
        patientId: patient.id,
        uploadType: "patient-form-data",
      },
    });

    const blobUrl = blockBlobClient.url;

    return {
      success: true,
      blobUrl,
    };
  } catch (error) {
    console.error("Azure upload error:", error);
    return {
      success: false,
      error: `Failed to upload to Azure Blob Storage: ${(error as Error).message}`,
    };
  }
}

export async function testAzureConnection(): Promise<{ connected: boolean; error?: string }> {
  try {
    if (!blobServiceClient) {
      throw new Error("Azure Blob Service Client not initialized");
    }

    const containerClient = blobServiceClient.getContainerClient(containerName);
    await containerClient.getProperties();
    
    return { connected: true };
  } catch (error) {
    return { 
      connected: false, 
      error: (error as Error).message 
    };
  }
}
