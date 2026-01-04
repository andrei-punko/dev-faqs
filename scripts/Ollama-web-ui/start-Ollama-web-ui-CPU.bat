
echo "Start Ollama web-ui with CPU support"

docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

echo "You can access Open WebUI at http://localhost:3000"
