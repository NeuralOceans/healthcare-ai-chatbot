import { useQuery } from "@tanstack/react-query";
import { ChatInterface } from "@/components/chat-interface";
import { PatientForm } from "@/components/patient-form";
import { Heart, Settings } from "lucide-react";
import { Button } from "@/components/ui/button";

export default function HealthcareDashboard() {
  const { data: azureStatus } = useQuery<{ connected: boolean; error?: string }>({
    queryKey: ["/api/azure/status"],
  });

  return (
    <div className="min-h-screen bg-bg-clean">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-medical-blue rounded-lg flex items-center justify-center">
                <Heart className="w-5 h-5 text-white" />
              </div>
              <div>
                <h1 className="text-xl font-semibold text-gray-900">HealthCare AI Assistant</h1>
                <p className="text-sm text-neutral-gray">Patient Data Management System</p>
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <div className="flex items-center space-x-2 text-sm text-neutral-gray">
                <div 
                  className={`w-2 h-2 rounded-full ${
                    azureStatus?.connected ? "bg-success-green" : "bg-error-red"
                  }`}
                />
                <span data-testid="azure-connection-status">
                  {azureStatus?.connected ? "Azure Connected" : "Azure Disconnected"}
                </span>
              </div>
              <Button variant="ghost" size="sm">
                <Settings className="w-4 h-4" />
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-5 gap-8 h-[calc(100vh-12rem)]">
          {/* Chat Interface Panel */}
          <div className="lg:col-span-2" data-testid="chat-interface-panel">
            <ChatInterface />
          </div>

          {/* Form Panel */}
          <div className="lg:col-span-3" data-testid="patient-form-panel">
            <PatientForm />
          </div>
        </div>
      </div>
    </div>
  );
}
