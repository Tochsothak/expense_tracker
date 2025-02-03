const express = require('express');
const db = require('../db');
const authenticate = require('../middleware/auth');
const router = express.Router();

// Add expense 
router.post('/add', authenticate , (req,res) => {
    const {amount, category, date , notes} = req.body;
    const userId = req.userId;

    db.run('INSERT INTO EXPENSE (USER_ID, AMOUNT, CATEGORY, DATE, NOTES) VALUES (?,?,?,?,?)',[userId, amount , category, date , notes],
        (err) => {
            if(err) return status(500).json({error : 'Failed to add expense'});

            res.status(201).json({message: 'Expense added successfully '});
        }
    )
});

// Get all Expense for a user
router.get('/', authenticate, (req, res)=>{
    db.all('SELECT * FROM EXPENSE WHERE USER_ID = ? ORDER BY DATE DESC', 
        [userId],
        (err, expenses) =>{
            if (err) return res.status(500).json({err: 'Failed to fetch expenses'});

            res.json(expenses);
        }
    )

})

// Delete expense
router.delete('/:id', authenticate, (req, res) =>{
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
})

module.exports = router;
