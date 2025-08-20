import { useEffect, useState } from "react";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import { CheckCircle, XCircle, Settings, Loader2 } from "lucide-react";

interface ProgressModalProps {
  isOpen: boolean;
  status: "ready" | "processing" | "success" | "error";
  onClose: () => void;
}

interface ProgressStep {
  id: string;
  text: string;
  progress: number;
}

const steps: ProgressStep[] = [
  { id: "step-1", text: "Generating realistic patient data", progress: 25 },
  { id: "step-2", text: "Validating form inputs", progress: 50 },
  { id: "step-3", text: "Uploading to Azure Blob Storage", progress: 75 },
  { id: "step-4", text: "Confirming successful submission", progress: 100 },
];

export function ProgressModal({ isOpen, status, onClose }: ProgressModalProps) {
  const [currentStep, setCurrentStep] = useState(0);
  const [progress, setProgress] = useState(0);
  const [currentText, setCurrentText] = useState("Initializing...");

  useEffect(() => {
    if (status === "processing" && isOpen) {
      setCurrentStep(0);
      setProgress(0);
      setCurrentText("Generating realistic patient data...");
      
      const stepInterval = setInterval(() => {
        setCurrentStep((prev) => {
          const next = prev + 1;
          if (next < steps.length) {
            setProgress(steps[next].progress);
            setCurrentText(steps[next].text + "...");
            return next;
          } else {
            clearInterval(stepInterval);
            return prev;
          }
        });
      }, 1500);

      return () => clearInterval(stepInterval);
    } else if (status === "success") {
      setProgress(100);
      setCurrentText("Successfully completed!");
    } else if (status === "error") {
      setCurrentText("An error occurred during processing");
    }
  }, [status, isOpen]);

  const getIcon = () => {
    switch (status) {
      case "success":
        return <CheckCircle className="w-16 h-16 text-success-green" />;
      case "error":
        return <XCircle className="w-16 h-16 text-error-red" />;
      default:
        return (
          <div className="w-16 h-16 bg-medical-blue rounded-full flex items-center justify-center">
            <Settings className="w-8 h-8 text-white animate-spin" />
          </div>
        );
    }
  };

  const getTitle = () => {
    switch (status) {
      case "success":
        return "Success!";
      case "error":
        return "Error";
      default:
        return "Processing Request";
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-md mx-4" data-testid="progress-modal">
        <div className="text-center p-4">
          <div className="flex justify-center mb-4">
            {getIcon()}
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-2" data-testid="progress-title">
            {getTitle()}
          </h3>
          <p className="text-neutral-gray mb-6" data-testid="progress-text">
            {currentText}
          </p>
          
          {status === "processing" && (
            <>
              {/* Progress Bar */}
              <div className="w-full bg-gray-200 rounded-full h-2 mb-4">
                <div 
                  className="bg-medical-blue h-2 rounded-full transition-all duration-500"
                  style={{ width: `${progress}%` }}
                  data-testid="progress-bar"
                />
              </div>
              
              {/* Progress Steps */}
              <div className="space-y-2 text-sm text-left">
                {steps.map((step, index) => (
                  <div
                    key={step.id}
                    className={`flex items-center space-x-2 transition-colors ${
                      index <= currentStep ? "text-medical-blue" : "text-neutral-gray"
                    }`}
                    data-testid={step.id}
                  >
                    {index <= currentStep ? (
                      <CheckCircle className="w-3 h-3" />
                    ) : (
                      <div className="w-3 h-3 rounded-full border border-current" />
                    )}
                    <span>{step.text}</span>
                    {index === currentStep && status === "processing" && (
                      <Loader2 className="w-3 h-3 animate-spin ml-auto" />
                    )}
                  </div>
                ))}
              </div>
            </>
          )}

          {status === "success" && (
            <div className="text-sm text-success-green mt-4">
              Patient record has been successfully uploaded to Azure Blob Storage
            </div>
          )}

          {status === "error" && (
            <div className="text-sm text-error-red mt-4">
              Please check your Azure configuration and try again
            </div>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
