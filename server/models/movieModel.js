const mongoose  = require('mongoose')
const bcrypt=require('bcryptjs')
const jwt=require ('jsonwebtoken')
const {JWT_SECRET} = require('../keys')

const MovieSchema = mongoose.Schema(
  {
    movieId: {
      type: String,
    },
    imdbID: {
      type: String,
      // required: true,
    },
    Title: {
      type: String,
    },
    Year: {
      type: String,
    },
    Runtime: {
      type: String,
    },
    Genre: {
      type: String,
      required: true,
    },
    Director: {
      type: String,
    
    },
    Writer:{
      type: String,

    },
    Actors:{
      type: String,

    },
    Plot:{
      type: String,

    },
    Language:{
      type: String,

    },
    description:{
      type: String,
      default:"The defiant leader Moses rises up against Egyptian Pharaoh Ramses II, setting six hundred thousand slaves on a monumental journey of escape from Egypt and its terrifying cycle of deadly plagues.  ",

    },
    Poster:{
      type: String,
default:"https://blog.hubspot.com/hs-fs/hubfs/parts-url-hero.jpg?width=595&height=400&name=parts-url-hero.jpg"
    },
    Type:{
      type: String,

    },
    status:{
      type: String,
      default:"active"

    },
  },
  {
    timestamps: true,
  }
);


const Movies = mongoose.model('Moveie', MovieSchema);
module.exports= Movies



