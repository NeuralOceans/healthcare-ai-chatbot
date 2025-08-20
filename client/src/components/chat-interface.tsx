import { useState, useRef, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import { ScrollArea } from "@/components/ui/scroll-area";
import { apiRequest } from "@/lib/queryClient";
import { useToast } from "@/hooks/use-toast";
import { type ChatMessage } from "@shared/schema";
import { Bot, User, Send, Heart } from "lucide-react";

export function ChatInterface() {
  const [inputMessage, setInputMessage] = useState("");
  const scrollAreaRef = useRef<HTMLDivElement>(null);
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const { data: messages = [], isLoading } = useQuery<ChatMessage[]>({
    queryKey: ["/api/chat/messages"],
  });

  const sendMessageMutation = useMutation({
    mutationFn: async (content: string) => {
      const response = await apiRequest("POST", "/api/chat/message", { content });
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/chat/messages"] });
      setInputMessage("");
    },
    onError: (error: Error) => {
      toast({
        title: "Error",
        description: `Failed to send message: ${error.message}`,
        variant: "destructive",
      });
    },
  });

  const handleSendMessage = () => {
    const trimmedMessage = inputMessage.trim();
    if (trimmedMessage && !sendMessageMutation.isPending) {
      sendMessageMutation.mutate(trimmedMessage);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  useEffect(() => {
    if (scrollAreaRef.current) {
      scrollAreaRef.current.scrollTop = scrollAreaRef.current.scrollHeight;
    }
  }, [messages]);

  return (
    <Card className="flex flex-col h-full">
      <div className="p-6 border-b border-gray-200">
        <div className="flex items-center space-x-3">
          <div className="w-8 h-8 bg-medical-blue rounded-full flex items-center justify-center">
            <Bot className="w-4 h-4 text-white" />
          </div>
          <div>
            <h2 className="text-lg font-semibold text-gray-900">AI Health Assistant</h2>
            <p className="text-sm text-neutral-gray">Ready to help with your form</p>
          </div>
        </div>
      </div>

      <CardContent className="flex-1 p-0 flex flex-col">
        <ScrollArea className="flex-1 p-6" ref={scrollAreaRef}>
          {isLoading ? (
            <div className="flex justify-center items-center h-32">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-medical-blue"></div>
            </div>
          ) : (
            <div className="space-y-4">
              {messages.map((message) => (
                <div
                  key={message.id}
                  className={`flex items-start space-x-3 ${
                    message.role === "user" ? "flex-row-reverse space-x-reverse" : ""
                  }`}
                >
                  <div
                    className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                      message.role === "user"
                        ? "bg-success-green"
                        : "bg-medical-blue"
                    }`}
                  >
                    {message.role === "user" ? (
                      <User className="w-3 h-3 text-white" />
                    ) : (
                      <Bot className="w-3 h-3 text-white" />
                    )}
                  </div>
                  <div className="flex-1">
                    <div
                      className={`rounded-lg p-4 ${
                        message.role === "user"
                          ? "bg-medical-blue text-white"
                          : "bg-gray-50 text-gray-900"
                      }`}
                    >
                      <p className="text-sm">{message.content}</p>
                    </div>
                    <p
                      className={`text-xs text-neutral-gray mt-1 ${
                        message.role === "user" ? "text-right" : ""
                      }`}
                    >
                      {message.role === "user" ? "You" : "AI Assistant"} • 
                      {message.timestamp && new Date(message.timestamp).toLocaleTimeString()}
                    </p>
                  </div>
                </div>
              ))}
              
              {sendMessageMutation.isPending && (
                <div className="flex items-start space-x-3 flex-row-reverse space-x-reverse">
                  <div className="w-8 h-8 bg-success-green rounded-full flex items-center justify-center flex-shrink-0">
                    <User className="w-3 h-3 text-white" />
                  </div>
                  <div className="flex-1">
                    <div className="bg-medical-blue text-white rounded-lg p-4">
                      <p className="text-sm">{inputMessage}</p>
                    </div>
                    <p className="text-xs text-neutral-gray mt-1 text-right">You • sending...</p>
                  </div>
                </div>
              )}
            </div>
          )}
        </ScrollArea>

        <div className="p-6 border-t border-gray-200">
          <div className="flex space-x-3">
            <Input
              type="text"
              placeholder="Ask me about the form or data generation..."
              value={inputMessage}
              onChange={(e) => setInputMessage(e.target.value)}
              onKeyPress={handleKeyPress}
              className="flex-1"
              disabled={sendMessageMutation.isPending}
              data-testid="input-chat-message"
            />
            <Button
              onClick={handleSendMessage}
              disabled={!inputMessage.trim() || sendMessageMutation.isPending}
              size="sm"
              className="bg-medical-blue hover:bg-blue-700"
              data-testid="button-send-message"
            >
              <Send className="w-4 h-4" />
            </Button>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
