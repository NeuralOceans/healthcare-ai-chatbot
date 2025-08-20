import { useState } from "react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { apiRequest } from "@/lib/queryClient";
import { useToast } from "@/hooks/use-toast";
import { insertPatientSchema, type GeneratedData } from "@shared/schema";
import { User, CreditCard, Wand2, CheckCircle, Eraser, Loader2 } from "lucide-react";
import { ProgressModal } from "@/components/progress-modal";

const formSchema = insertPatientSchema;

export function PatientForm() {
  const [showProgress, setShowProgress] = useState(false);
  const [formStatus, setFormStatus] = useState<"ready" | "processing" | "success" | "error">("ready");
  const { toast } = useToast();

  const form = useForm({
    resolver: zodResolver(formSchema),
    defaultValues: {
      fullName: "",
      email: "",
      birthday: "",
      ssn: "",
      creditCard: "",
      expiryDate: "",
      cvv: "",
    },
  });

  // Check Azure connection status
  const { data: azureStatus } = useQuery<{ connected: boolean; error?: string }>({
    queryKey: ["/api/azure/status"],
  });

  const generateAndSubmitMutation = useMutation({
    mutationFn: async () => {
      const response = await apiRequest("POST", "/api/patients/generate-and-submit");
      return response.json();
    },
    onMutate: () => {
      setShowProgress(true);
      setFormStatus("processing");
    },
    onSuccess: (data) => {
      // Populate form with generated data
      if (data.generatedData) {
        form.reset(data.generatedData);
      }
      
      setFormStatus("success");
      toast({
        title: "Success!",
        description: "Patient data generated and uploaded to Azure Blob Storage successfully.",
      });
      
      setTimeout(() => {
        setShowProgress(false);
      }, 2000);
    },
    onError: (error: Error) => {
      setFormStatus("error");
      toast({
        title: "Error",
        description: `Failed to generate and submit data: ${error.message}`,
        variant: "destructive",
      });
      
      setTimeout(() => {
        setShowProgress(false);
      }, 2000);
    },
  });

  const handleClearForm = () => {
    form.reset({
      fullName: "",
      email: "",
      birthday: "",
      ssn: "",
      creditCard: "",
      expiryDate: "",
      cvv: "",
    });
    setFormStatus("ready");
  };

  const handleValidateForm = () => {
    form.trigger().then((isValid) => {
      if (isValid) {
        toast({
          title: "Form Valid",
          description: "All form fields are properly filled and validated.",
        });
      } else {
        toast({
          title: "Validation Error",
          description: "Please check the form fields for errors.",
          variant: "destructive",
        });
      }
    });
  };

  const formatCreditCard = (value: string) => {
    const v = value.replace(/\s/g, '').replace(/[^0-9]/gi, '');
    const matches = v.match(/.{1,4}/g);
    const match = matches && matches.length > 0 ? matches.join(' ') : '';
    return match.length > 0 ? match : '';
  };

  const formatSSN = (value: string) => {
    const v = value.replace(/\D/g, '');
    if (v.length >= 6) {
      return v.substring(0,3) + '-' + v.substring(3,5) + '-' + v.substring(5,9);
    } else if (v.length >= 4) {
      return v.substring(0,3) + '-' + v.substring(3);
    }
    return v;
  };

  const getStatusIndicator = () => {
    switch (formStatus) {
      case "processing":
        return (
          <div className="flex items-center space-x-2 text-sm">
            <div className="w-2 h-2 bg-yellow-400 rounded-full animate-pulse"></div>
            <span className="text-yellow-600">Processing...</span>
          </div>
        );
      case "success":
        return (
          <div className="flex items-center space-x-2 text-sm">
            <div className="w-2 h-2 bg-success-green rounded-full"></div>
            <span className="text-success-green">Successfully submitted to Azure</span>
          </div>
        );
      case "error":
        return (
          <div className="flex items-center space-x-2 text-sm">
            <div className="w-2 h-2 bg-error-red rounded-full"></div>
            <span className="text-error-red">Submission failed</span>
          </div>
        );
      default:
        return (
          <div className="flex items-center space-x-2 text-sm">
            <div className="w-2 h-2 bg-gray-400 rounded-full"></div>
            <span className="text-neutral-gray">Ready to generate</span>
          </div>
        );
    }
  };

  return (
    <>
      <Card className="h-full">
        <div className="p-6 border-b border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-xl font-semibold text-gray-900">Patient Information Form</h2>
              <p className="text-sm text-neutral-gray mt-1">Generate and submit patient data to Azure Blob Storage</p>
            </div>
            <div data-testid="status-indicator">
              {getStatusIndicator()}
            </div>
          </div>
        </div>

        <CardContent className="p-6">
          <Form {...form}>
            <form className="space-y-6">
              {/* Personal Information Section */}
              <div className="bg-gray-50 rounded-lg p-6">
                <h3 className="text-lg font-medium text-gray-900 mb-4 flex items-center">
                  <User className="w-5 h-5 text-medical-blue mr-2" />
                  Personal Information
                </h3>
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <FormField
                    control={form.control}
                    name="fullName"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Full Name</FormLabel>
                        <FormControl>
                          <Input
                            placeholder="Enter full name"
                            {...field}
                            data-testid="input-full-name"
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="email"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Email Address</FormLabel>
                        <FormControl>
                          <Input
                            type="email"
                            placeholder="Enter email address"
                            {...field}
                            data-testid="input-email"
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="birthday"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Date of Birth</FormLabel>
                        <FormControl>
                          <Input
                            type="date"
                            {...field}
                            data-testid="input-birthday"
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="ssn"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Social Security Number</FormLabel>
                        <FormControl>
                          <Input
                            placeholder="XXX-XX-XXXX"
                            maxLength={11}
                            {...field}
                            onChange={(e) => {
                              const formatted = formatSSN(e.target.value);
                              field.onChange(formatted);
                            }}
                            data-testid="input-ssn"
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
              </div>

              {/* Payment Information Section */}
              <div className="bg-gray-50 rounded-lg p-6">
                <h3 className="text-lg font-medium text-gray-900 mb-4 flex items-center">
                  <CreditCard className="w-5 h-5 text-medical-blue mr-2" />
                  Payment Information
                </h3>
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <FormField
                    control={form.control}
                    name="creditCard"
                    render={({ field }) => (
                      <FormItem className="md:col-span-2">
                        <FormLabel>Credit Card Number</FormLabel>
                        <FormControl>
                          <Input
                            placeholder="XXXX XXXX XXXX XXXX"
                            maxLength={19}
                            {...field}
                            onChange={(e) => {
                              const formatted = formatCreditCard(e.target.value);
                              field.onChange(formatted);
                            }}
                            data-testid="input-credit-card"
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="expiryDate"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Expiry Date</FormLabel>
                        <FormControl>
                          <Input
                            placeholder="MM/YY"
                            maxLength={5}
                            {...field}
                            data-testid="input-expiry-date"
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="cvv"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>CVV</FormLabel>
                        <FormControl>
                          <Input
                            placeholder="XXX"
                            maxLength={4}
                            {...field}
                            data-testid="input-cvv"
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
              </div>

              {/* Action Buttons */}
              <div className="flex items-center justify-between pt-6 border-t border-gray-200">
                <div className="flex items-center space-x-4">
                  <Button
                    type="button"
                    variant="outline"
                    onClick={handleClearForm}
                    data-testid="button-clear-form"
                  >
                    <Eraser className="w-4 h-4 mr-2" />
                    Clear Form
                  </Button>
                  <Button
                    type="button"
                    variant="secondary"
                    onClick={handleValidateForm}
                    data-testid="button-validate-form"
                  >
                    <CheckCircle className="w-4 h-4 mr-2" />
                    Validate
                  </Button>
                </div>
                
                <Button
                  type="button"
                  onClick={() => generateAndSubmitMutation.mutate()}
                  disabled={generateAndSubmitMutation.isPending}
                  className="bg-medical-blue hover:bg-blue-700 transform hover:scale-105 shadow-lg"
                  data-testid="button-generate-submit"
                >
                  {generateAndSubmitMutation.isPending ? (
                    <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                  ) : (
                    <Wand2 className="w-4 h-4 mr-2" />
                  )}
                  Generate & Submit to Azure
                </Button>
              </div>
            </form>
          </Form>
        </CardContent>
      </Card>

      <ProgressModal 
        isOpen={showProgress}
        status={formStatus}
        onClose={() => setShowProgress(false)}
      />
    </>
  );
}
