const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello from Service 1!\n');
});

const PORT = 3000;
server.listen(PORT, () => {
  console.log(`Service 1 is running on port ${PORT}`);
});
