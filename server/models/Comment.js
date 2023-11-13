const mongoose = require('mongoose');

const fileSchema = mongoose.Schema(
  {
    userName: {
      type: String,
  
    },
    id: {
      type: String,
 
    },
    content: {
      type: String,
      
    },
  
  },
  {
    timestamps: true
  }
);

const File = mongoose.model('Comment', fileSchema);

module.exports = File;
