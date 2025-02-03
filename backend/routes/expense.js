const express = require('express');
const db = require('../db');
const authenticateToken = require('../middleware/auth');

const router = express.Router();

// Add expense 
router.post('/add', authenticateToken ,async (req,res) => {
    const { amount, category, date, notes } = req.body;
    const userId = req.user.id;  // Extract USER_ID from JWT

    if (!amount || !category || !date || !userId) {
        return res.status(400).json({ error: "Missing required fields" });
    }

    try {
        await db.run(
            `INSERT INTO EXPENSE (USER_ID, AMOUNT, CATEGORY, DATE, NOTES) VALUES (?, ?, ?, ?, ?)`,
            [userId, amount, category, date, notes]
        );
        res.json({ message: "Expense added successfully" });
    } catch (err) {
        res.status(500).json({ error: "Failed to add expense" });
    }
});

// Delete expense
router.delete('/:id', authenticateToken, (req, res) =>{
    const expenseId = req.params.id;
    const userId = userId = req.userId;
    
    db.run(
        'DELETE FROM EXPENSE WHERE ID = ? AND USER_ID = ?',
        [expenseId, userId],
        (err) => {
            if(err) return res.status(500).json({error: 'Failed to delete expense'});
            res.json({message: 'Expense deleted successfully'});

        }
        
    )
});

// Get all expenses for the logged-in user
router.get('/', authenticateToken, async (req, res) => {
    const userId = req.user.id; // Extract USER_ID from JWT

    try {
        const expenses = await db.all(
            `SELECT * FROM EXPENSE WHERE USER_ID = ? ORDER BY DATE DESC`,
            [userId]
        );

        // Return an empty array if no expenses are found
        res.json(expenses || []);
    } catch (err) {
        res.status(500).json({ error: "Failed to fetch expenses" });
    }
});

// Get Monthly Sumary
router.get('/summary', authenticateToken, (req, res) => {
    const userId = req.userId;

    db.all(
        `SELECT CATEGORY, SUM(AMOUNT) AS TOTAL FROM EXPENSE
        WHERE USER_ID = ? AND strftime('%Y-%m', DATE) = strftime('%Y-%m', 'now')
        GROUP BY CATEGORY`,
        [userId],
        (err, summary) => {
            if (err) return res.status(500).json({error: 'Failed to fetch summary '});
            res.json(summary);
        } 
    )
})

module.exports = router;
