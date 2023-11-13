const mongoose  = require('mongoose')
const bcrypt=require('bcryptjs')
const jwt=require ('jsonwebtoken')
const {JWT_SECRET} = require('../keys')

const userSchema = mongoose.Schema(
  {
    empid: {
      type: String,
    },
    name: {
      type: String,
      // required: true,
    },
    username: {
      type: String,
    },
    gender: {
      type: String,
    },
    email: {
      type: String,
      required: true,
    },
    password: {
      type: String,
      required: true,
    },
    role: {
      type: String,
    
    },
    oid:{
      type: String,

    },
    bio: {
      type: String,
      default: 'Available',
    },
    mobile: {
      type: String,
  
    },
    
  
    status: {
      type: String,
      default: 'active',

    },
    profilePic: {
      type: String,
      default:
        'https://icon-library.com/images/anonymous-avatar-icon/anonymous-avatar-icon-25.jpg',
    },
    contacts: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
      },
    ],
  },
  {
    timestamps: true,
  }
);
userSchema.pre('save', async function (next) {
  if (this.isModified('password')) {
    this.password = await bcrypt.hash(this.password, 12);
  }
  next();
});
userSchema.methods.generateAuthToken = async function () {
  try {
    let token = jwt.sign(
      { id: this._id, email: this.email },
      process.env.SECRET,
      {
        expiresIn: '24h',
      }
    );

    // const generateToken = (id) => {
    //   return jwt.sign({ id }, JWT_SECRET, {
    //     expiresIn: "30d",
    //   });
    // };
    return token;
  } catch (error) {
    console.log('error while generating token');
  }
};
userSchema.pre('save', async function (next) {
  try {
    if (!this.empid) {
      const lastEmployee = await userModel.findOne({}, {}, { sort: { empid: -1 } });

      if (lastEmployee) {
        const lastEmployeeId = parseInt(lastEmployee.empid.slice(2));
        this.empid = 'E-' + ('0000' + (lastEmployeeId + 1)).slice(-4);
      } else {
        this.empid = 'E-0001';
      }
    }

    next();
  } catch (error) {
    next(error);
  }
});

const userModel = mongoose.model('UserModel', userSchema);
module.exports= userModel



