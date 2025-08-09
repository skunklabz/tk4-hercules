const express = require('express');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Simple health endpoint for docker-compose healthcheck
app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

// Serve static public directory if present
const publicDir = path.join(__dirname, 'public');
app.use(express.static(publicDir));

// Root route renders minimal page if no static index
app.get('/', (_req, res) => {
  res.send(`<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>TK4-Hercules LMS</title>
  </head>
  <body>
    <div id="app">
      <div id="sidebar"></div>
      <div id="main-panel">
        <div id="welcome-screen"></div>
        <div id="exercise-view"></div>
      </div>
    </div>
  </body>
</html>`);
});

app.listen(port, () => {
  // eslint-disable-next-line no-console
  console.log(`LMS listening on http://localhost:${port}`);
});

