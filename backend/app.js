const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

const db = require('./db')

// For managing environment variable
dotenv.config();

const app = express();
const authRoutes = require('./routes/auth')
app.use('/api/auth', authRoutes)

const expenseRoutes = require('./routes/expense');

app.use('/api/expense', expenseRoutes);

app.use(cors()); //  enable cors for all route(cross origin)
app.use(express.json());

const PORT = process.env.PORT || 5000;
app.listen(PORT, () =>{
    console.log(`Server running on port ${PORT}`);
}) 


