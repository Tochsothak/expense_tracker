const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require ('jsonwebtoken');
const db = require('../db');
const router = express.Router();

// Sign up route
router.post('/signup', async (req, res) => {
    const {username, email, password} = req.body;
    const hashedPass = await bcrypt.hash(password, 10);

    db.run(
        'INSERT INTO USERS (USERNAME, EMAIL , HASHEDPASS) VALUES (?,?,?)',
        [username,email,hashedPass],
        (err) => {
            if (err) return res.status(400).json({error: 'User already exists'});
            res.status(201).json({ message : 'User created successfully '});
        }

    )
})

// Login route
router.post('/login', (req, res) => {
    const  {email, password} = req.body;

    db.get('SELECT * FROM USERS WHERE EMAIL = ?', [email], async (err,user) => {
        if (err || !user) return res.status(400).json({err : 'Invalid credentials'});

        const token = jwt.sign({id: user.ID}, process.env.JWT_SECRET, {expiresIn: '1'});
        res.json({token});
    })
})


module.exports = router
