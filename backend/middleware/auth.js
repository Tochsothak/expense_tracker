const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
  const authHeader = req.header('Authorization');
  console.log("Authorization header:", authHeader);

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Access denied: No token provided' });
  }

  const token = authHeader.replace('Bearer ', '');
  console.log("Received token:", token);

  if (!token) {
    return res.status(401).json({ error: 'Access denied: Invalid token format' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log("Decoded token:", decoded);
    req.user = decoded;
    next();
  } catch (err) {
    console.log("Token verification failed:", err);
    res.status(401).json({ error: 'Invalid token' });
  }
};

module.exports = authenticateToken;