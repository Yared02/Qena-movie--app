const express = require('express');
const dotenv = require('dotenv/config');
const mongoDBConnect = require('./mongoDB/connection.js');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const userRoutes1 = require('./routes/user1.js');
const Movie = require('./routes/Movie');
const Comment = require('./routes/commnet');
const path = require('path');

const app = express();
const corsConfig = {
  origin: '*',
  credentials: true,
};
// app.use(cors(corsConfig));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors(corsConfig));
app.use('/api', userRoutes1);
app.use(Movie);
app.use(Comment);




app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
const commentSchema = new mongoose.Schema({
  id:String,
  text: String,
  userName:String,
  replies: [{ text: String,userName34:String }],
  rating: { type: Number, default: 0 }, // New property

});

const Comment23 = mongoose.model('Comment34', commentSchema);

app.use(bodyParser.json());

// API to get comments
app.get('/api/comments', async (req, res) => {
  try {
    const comments = await Comment23.find();
    res.json(comments);
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});
app.get('/api/comments/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const comment = await Comment23.find({id:id});
    
    if (!comment) {
      return res.status(404).json({ message: 'Comment not found' });
    }
    
    res.json(comment);
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});
app.post('/api/comments/:id/rate', async (req, res) => {
  try {
    const { id } = req.params;
    const { rating } = req.body;

    const comment = await Comment23.findById(id);
    comment.rating = rating;
    await comment.save();

    res.status(200).json(comment);
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
})
// API to add a comment
app.post('/api/comments', async (req, res) => {
  try {
    const { text,userName,id } = req.body;
    const newComment = new Comment23({ text,userName,id });
    await newComment.save();
    res.status(201).json(newComment);
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});

// API to add a reply to a comment
app.post('/api/comments/:id/replies', async (req, res) => {
  try {
    const { id } = req.params;
    const { text } = req.body;
    const { username } = req.body;

console.log(req.body)
    const comment = await Comment23.findById(id);
    comment.replies.push({ text:text,userName34:username });
    await comment.save();

    res.status(201).json(comment);
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});




mongoose.set('strictQuery', false);
mongoDBConnect();
const server = app.listen(process.env.PORT, () => {
  console.log(`Server Listening at PORT - ${process.env.PORT}`);
});
