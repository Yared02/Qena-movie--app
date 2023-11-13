const jwt = require('jsonwebtoken');
//const secretKey = process.env.SECRET_KEY; // Secret key used to sign JWT tokens
const {JWT_SECRET} = require('../keys')
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers.authorization;
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return  res.status(403).json({ message: 'please login first' });
}

  jwt.verify(token, JWT_SECRET, (err, decoded) => {
    if (err) {
      //return res.sendStatus(403); // Forbidden
      return  res.status(403).json({ message: 'please login first' });

    }

    req.user = decoded; // Store the decoded token in the request object
    next();
  });
};

module.exports = { authenticateToken };



//const {JWT_SECRET} = require('../keys')