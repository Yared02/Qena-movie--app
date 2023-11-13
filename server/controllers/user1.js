const user =require( '../models/userModel1.js')
const bcrypt =require('bcryptjs')


const express = require('express');
const multer = require('multer');
const path = require('path');



// Set up multer storage configuration
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


 const register = async (req, res) => {
  const { firstname, lastname, email, password,gender,mobile,username,role,oid } = req.body;
  console.log(req.body)
  const lastEmployee = await user.findOne().sort({ empid: -1 });
  let newEmployeeId = 'E-0001';

  if (lastEmployee) {
    const lastEmployeeId = lastEmployee.empid;
    const lastId = parseInt(lastEmployeeId.substring(2), 10);
    newEmployeeId = `E-${('0000' + (lastId + 1)).slice(-4)}`;
  }
  try {
    const existingUser = await user.findOne({ email });
    if (existingUser)
      return res.status(400).json({ error: 'User already Exits' });
      const file = req.file;
    
      const fullName = firstname +' '+ lastname;
      const newuser = new user({ email, password,mobile,oid, name: fullName,empid:newEmployeeId,username,gender,role });
 
    // const token = await newuser.generateAuthToken();
    await newuser.save();
  
    res.json({ message: 'success', });
  } catch (error) {
    console.log('Error in register ' + error);
    res.status(500).send(error);
  }
};
 const login = async (req, res) => {
  const { email, password } = req.body;
  console.log(req.body)
  try {
    const valid = await user.findOne({ email });
    // if (!valid) res.status(401).json({ message: 'User dont exist' });


if(valid.status=="inactive"){
  return res.status(401).json({ message: 'Your  personal Account is inactive' });


}

    const validPassword = await bcrypt.compare(password, valid.password);
    if (!validPassword) {
      res.status(400).json({ message: 'Invalid Credentials' });
    } else {
      const token = await valid.generateAuthToken();
      await valid.save();
      res.cookie('userToken', token, {
        httpOnly: true,
        maxAge: 24 * 60 * 60 * 1000,
      });
      // console.log(token)


     return res.status(200).json({ 
        token: token,firstname:valid.name,_id:valid._id,
        role:valid.role,gender:valid.gender,
        email:valid.email,
        oid:valid.oid,username:valid.username,empid:valid.empid,
     
      });
    }
  } catch (error) {
    res.status(500).json({ error: error });
    console.log(res.status)
  }
};
 const validUser = async (req, res) => {
  try {
    const validuser = await user
      .findOne({ _id: req.rootUserId })
      .select('-password');
    if (!validuser) res.json({ message: 'user is not valid' });
    res.status(201).json({
      user: validuser,
      token: req.token,
    });
  } catch (error) {
    res.status(500).json({ error: error });
    console.log(error);
  }
};


 const logout = (req, res) => {
  req.rootUser.tokens = req.rootUser.tokens.filter((e) => e.token != req.token);
};
 const searchUsers = async (req, res) => {
  // const { search } = req.query;
  const search = req.query.search
    ? {
        $or: [
          { name: { $regex: req.query.search, $options: 'i' } },
          { email: { $regex: req.query.search, $options: 'i' } },
        ],
      }
    : {};

  const users = await user.find(search).find({ _id: { $ne: req.rootUserId } });
  res.status(200).send(users);
};
 const getUserById = async (req, res) => {
  const { id } = req.params;
  try {
    const selectedUser = await user.findOne({ _id: id }).select('-password');
    res.status(200).json(selectedUser);
  } catch (error) {
    res.status(500).json({ error: error });
  }
};
 const updateInfo = async (req, res) => {
  const { id } = req.params;
  const { bio, name } = req.body;
  const updatedUser = await user.findByIdAndUpdate(id, { name, bio });
  return updatedUser;
};
module.exports = {
  register,
  updateInfo,
  getUserById,
  searchUsers,
  logout,
  validUser,
  login,

};
