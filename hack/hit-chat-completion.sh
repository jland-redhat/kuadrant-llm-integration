curl -i -v -X POST \
  https://infra-simple-inference-gateway-istio-istio-llm-d.apps.agentops-prod.m5kq.p1.openshiftapps.com/v1/completions \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "model": "meta-llama/Llama-3.1-8B-Instruct",
    "prompt": "Meowdy partner",
    "max_tokens": 50
      }'