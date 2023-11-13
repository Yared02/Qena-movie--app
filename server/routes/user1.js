// import express from 'express';
const express = require('express')
const multer = require('multer');
const path = require('path');
const User =require('../models/userModel1')

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    const extname = path.extname(file.originalname);
    const filename = file.fieldname + '-' + uniqueSuffix + extname;
    cb(null, filename);
  },
});
const upload = multer({ storage });

const {
  register,
  login,
  validUser,
  logout,
  searchUsers,
  updateInfo,
  getUserById,
} = require('../controllers/user1.js')

const { Auth }= require ('../middleware/user.js')
const router = express.Router();
router.post('/auth/register',  register);
router.post('/auth/login', login);
router.get('/auth/valid', Auth, validUser);
router.get('/auth/logout', Auth, logout);
router.get('/api/user?', Auth, searchUsers);
router.get('/api/users/:id', Auth, getUserById);
router.patch('/api/users/update/:id', Auth, updateInfo);

router.get('/getuser', (req, res) => {
  const { q } = req.query; // Search query parameter

  let searchQuery = {
  };

  // Add search query if q parameter is provided
  if (q) {
    searchQuery = {
      $and: [
        searchQuery,
        {
          $or: [
            { name: { $regex: q, $options: 'i' } },
            { email: { $regex: q, $options: 'i' } },
          ],
        },
      ],
    };
  }

  // Find document(s) in the collection based on the organization ID and search query
  User.find(searchQuery).exec(function (err, docs) {
    if (err) {
      console.log('Error retrieving data from MongoDB:', err);
      res.status(500).json({ error: 'Failed to retrieve data from the database' });
      return;
    }

    // Check if any document(s) matching the criteria were found
    if (docs.length === 0) {
      res.status(404).json({ error: 'No matching document(s) found' });
      return;
    }

    res.json(docs);
  });
});
router.put('/update-user45/:id', (req, res) => {
  User.findByIdAndUpdate(req.params.id, req.body)
    .then(data => {
      // Emit 'new employee' event to notify clients
      socket.emit('new employee', data);
      res.json({ msg: 'Data updated successfully' });
    })
    .catch(err => res.status(400).json({ error: 'Unable to update this data' }));
});

router.delete('/delete-user/:id', (req, res) =>{
  User.findByIdAndRemove(req.params.id, req.body)
  .then(data => res.json({ msg: 'Data deleted successfully' }))
  .catch(err => res.status(400).json({ error: 'Unable to delete this data' }));
})
module.exports = router