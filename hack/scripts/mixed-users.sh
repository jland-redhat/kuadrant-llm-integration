export MODEL="meta-llama/Llama-3.2-3B-Instruct"
export MODEL_URL="https://vllm-gateway-istio-llm-d.apps.rosa.jland-llm-d.ejia.p3.openshiftapps.com/"

# Premium user usage
echo "=== Premium User Usage ==="
for i in {1..8}; do
  printf "Premium req #%-2s -> " "$i"
  curl -s -o /dev/null -w "%{http_code}\n" \
       -X POST $MODEL_URL/v1/completions \
       -H 'Authorization: APIKEY premiumuser1_key' \
       -H 'Content-Type: application/json' \
       -d '{"model":"$MODEL","prompt":"Premium request","max_tokens":20}'
done

# Free user usage (will hit limits)
echo "=== Free User Usage ==="
for i in {1..5}; do
  printf "Free req #%-2s -> " "$i"
  curl -s -o /dev/null -w "%{http_code}\n" \
       -X POST $MODEL_URL/v1/completions \
       -H 'Authorization: APIKEY freeuser1_key' \
       -H 'Content-Type: application/json' \
       -d '{"model":"Qwen/Qwen3-0.6B","prompt":"Free request","max_tokens":10}'
done

# Another premium user
echo "=== Another Premium User ==="
for i in {1..6}; do
  printf "Premium2 req #%-2s -> " "$i"
  curl -s -o /dev/null -w "%{http_code}\n" \
       -X POST $MODEL_URL/v1/completions \
       -H 'Authorization: APIKEY premiumuser2_key' \
       -H 'Content-Type: application/json' \
       -d '{"model":"$MODEL","prompt":"Premium2 request","max_tokens":15}'
done