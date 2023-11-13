const express = require('express')
const router = express.Router()

const fs = require('fs');

const upload = require("../middleware/multer");

const Comment = require('../models/Comment')




router.post('/addComment', async (req, res) => {
  try {
    const {userName, id,content,
      } = req.body;
      console.log(req.body)
      // const file = req.file.path;

    const QQ = new Comment({
      userName, id,content,


    });

    const newQQ = await QQ.save();
    res.status(201).json(newQQ);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});

// router.get('/getComment',async  (req, res) => {
//   try {
//     const movieData = await Comment.find();
//     res.json(movieData);
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: 'Server Error' });
//   }
// });

router.get('/getComment/:id',async  (req, res) => {
  try {
    const{id}=req.params
    const Comment1 = await Comment.find({id:req.params.id});
    res.json(Comment1);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});
//my update api code
router.put('/update-movie/:id', (req, res) => {
  Movie.findByIdAndUpdate(req.params.id, req.body)
    .then(data => res.json({ msg: 'Data updated successfully' }))
    .catch(err => res.status(400).json({ error: 'Unable to update this data' }));
  });
//my Delete api code
  router.delete('/delete-movie/:id', (req, res) =>{
    Movie.findByIdAndRemove(req.params.id, req.body)
      .then(data => res.json({ msg: 'Data deleted successfully' }))
      .catch(err => res.status(400).json({ error: 'Unable to delete this data' }));
    })
 

module.exports = router