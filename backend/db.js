const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('expense_tracker.db', (err) => {
    if (err) {
        console.log(err.message);
    } else {
        console.log('Connected to the SQLite database');
    }
});

db.serialize(() => {
    db.run(
        `CREATE TABLE IF NOT EXISTS USERS(
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        USERNAME TEXT UNIQUE NOT NULL,
        EMAIL TEXT UNIQUE NOT NULL,
        HASHED_PASS TEXT NOT NULL
        )`
    );
    db.run(`CREATE TABLE IF NOT EXISTS EXPENSE(
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        USER_ID INTEGER,
        AMOUNT DECIMAL(10, 2) NOT NULL,
        CATEGORY TEXT NOT NULL,
        DATE TEXT NOT NULL,
        NOTES TEXT,
        FOREIGN KEY (USER_ID) REFERENCES USERS(ID)
        )`
    );
});

module.exports = db;