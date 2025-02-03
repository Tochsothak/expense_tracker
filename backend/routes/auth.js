const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require ('jsonwebtoken');
const db = require('../db');
const router = express.Router();

// Sign up route
router.post('/signup', async (req, res) => {
    const {username, email, password} = req.body;
    db.get('SELECT * FROM USERS WHERE EMAIL = ?', [email], async (err, row) => {
        if (row) return res.status(400).json({ error: 'Email already exists' });

        const hashedPassword = await bcrypt.hash(password, 10);
        db.run(
            'INSERT INTO USERS (USERNAME, EMAIL, HASHED_PASS) VALUES (?, ?, ?)',
            [username, email, hashedPassword],
            function (err) {
                if (err) return res.status(500).json({ error: 'Database error' });
                res.status(201).json({ message: 'User registered successfully' });
            }
        );
    });
   
})

// Login route
router.post('/login', async (req, res) => {
    const  {email, password} = req.body;

    if(!email || !password) {
        return res.status(400).json({error : 'Email and password are required'});
    }
    try {
        db.get('SELECT * FROM USERS WHERE EMAIL = ?', [email], async (err,user) => {
            if (err || !user) return res.status(400).json({err : 'User not found'});

            const isValid = await bcrypt.compare(password, user.HASHED_PASS);
            if(!isValid){
                return res.status(401).json({error: 'Invalid password'});
            }
    
            const token = jwt.sign({id: user.ID, email: user.EMAIL}, process.env.JWT_SECRET, {expiresIn: '1h'});
            res.json({token});
        })
    } 
    catch(err){
        console.error('Error during  Login:', err);
        res.status(500).json({error: 'Interval server error'});

    }
})


module.exports = router
