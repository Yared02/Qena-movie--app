const express = require('express')
const router = express.Router()

const fs = require('fs');
const path = require("path");

const upload = require("../middleware/multer");

const Movie = require('../models/movieModel')

router.get('/getAllMovie', (req, res) => {
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
            { Title: { $regex: q, $options: 'i' } },
            { Writer: { $regex: q, $options: 'i' } },
            { Actors: { $regex: q, $options: 'i' } },

            { Director: { $regex: q, $options: 'i' } },

          ],
        },
      ],
    };
  }

  // Find document(s) in the collection based on the organization ID and search query
  Movie.find(searchQuery).exec(function (err, docs) {
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


router.post('/addMovie',upload.single('file'), async (req, res) => {
  try {
    const {movieId, description,Title, Year, Runtime, Genre, Director ,Writer, Plot ,Actors,Language ,Type
      } = req.body;
      const file = req.file.path;
console.log(file)
    const QQ = new Movie({
      movieId,Title, Year, Runtime, Genre,description, Director ,Writer, Plot ,Actors,Language ,Type,Poster:file


    });

    const newQQ = await QQ.save();
    res.status(201).json(newQQ);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});


router.get('/get-Romance',async  (req, res) => {
  try {
    const movieData = await Movie.find({Type:"Romance"});
    res.json(movieData);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});
router.get('/get-Action',async  (req, res) => {
  try {
    const movieData = await Movie.find({Type:"Action"});
    res.json(movieData);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});
router.get('/get-War',async  (req, res) => {
  try {
    const movieData = await Movie.find({Type:"War"});
    res.json(movieData);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});
router.get('/get-Documentary',async  (req, res) => {
  try {
    const movieData = await Movie.find({Type:"Documentary"});
    res.json(movieData);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});
router.get('/getMovie',async  (req, res) => {
  try {
    const movieData = await Movie.find();
    res.json(movieData);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});

router.get('/api/poster/:id', (req, res) => {
  // Find the image by ID in the database
  Movie.findById(req.params.id, (err, image) => {
    if (err) {
      console.log(err);
      res.status(500).json({ error: 'Failed to retrieve image' });
    } else {
      // const filePath = path.join(__dirname, image.file); // Assuming image.file contains the relative path to the file
      const filePath = path.join(__dirname, `../${image.Poster}`);

      res.sendFile(filePath);
    }
  });
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