const http = require("http");

const port = process.env.PORT || 10000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/plain" });
  res.end("Serveur Render opérationnel\n");
});

server.listen(port, "0.0.0.0", () => {
  console.log(`Serveur démarré sur le port ${port}`);
});
