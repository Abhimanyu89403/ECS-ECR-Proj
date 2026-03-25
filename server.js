const express = require('express');
const app = express();

// ECS containers usually expose environment variables
const PORT = process.env.PORT || 3000;
const APP_NAME = process.env.APP_NAME || "ECS Node App";

app.use(express.json());

// Root endpoint
app.get('/', (req, res) => {
    res.send(`Welcome to ${APP_NAME} running on ECS 🚀`);
});

// Health check endpoint (important for ECS / ALB health checks)
app.get('/health', (req, res) => {
    res.status(200).json({
        status: "healthy",
        service: APP_NAME,
        timestamp: new Date()
    });
});

// Example API endpoint
app.get('/api/info', (req, res) => {
    res.json({
        container: process.env.HOSTNAME,
        message: "Running inside AWS ECS",
        time: new Date()
    });
});

app.listen(PORT, () => {
    console.log(`Server started on port ${PORT}`);
});