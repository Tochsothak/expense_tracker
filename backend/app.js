const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
// For managing environment variable
dotenv.config();

const app = express();

//Middleware
app.use(cors()); //enable CORS for all routes
app.use(express.json()); // parse JSON request body

//Routes
const authRoutes = require('./routes/auth')
const expenseRoutes = require('./routes/expense');

app.use('/api/auth', authRoutes)
app.use('/api/expense', expenseRoutes);

//Database connection
const db = require('./db');

//start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () =>{
    console.log(`Server running on port ${PORT}`);
}) 


