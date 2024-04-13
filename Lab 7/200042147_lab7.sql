use SocialMedia;

db.posts.deleteMany({});
db.users.deleteMany({});


//2.A
db.users.insertOne({
  "name": "tawfiq",
  "email": "tawfiqeelahi@iut-dhaka.edu",
  "password": "123"
});

//2.B
db.users.insertMany([
   {
   "name": "elahi",
   "email": "elahi@gmail.com",
   "password": "456",
   "phone_no": "987678999",
   "date_of_birth": ISODate("1999-09-24"),
   "address": "Dhaka",
   "profile_creation": ISODate("2023-02-04"),
   "hobbies": ["reading", "chess"]
   },
  {
    "name": "tamzid",
    "email": "tamzid@gmail.com",
    "password": "toxic",
    "phone_no": "45768747856",
    "date_of_birth": ISODate("2001-03-06"),
    "address": "Dhaka",
    "profile_creation": ISODate("2023-12-11"),
    "hobbies": ["reading", "gaming"]
  }]
);


//2.C
db.users.insertOne({
  "name": "tees",
  "email": "tees@gmail.com",
  "password": "haha",
  "phone_no": "546456456591",
  "date_of_birth": ISODate("1980-01-01"),
  "address": "Tongi",
  "profile_creation": ISODate("2023-03-01"),
  "working_status": "Q/A Engineer"
});



//2.D
db.users.updateOne({ "email": "elahi@gmail.com" }, { $addToSet: { "followers": "Dayan" } });
db.users.updateOne({ "email": "tamzid@gmail.com" }, { $addToSet: { "followers": "Shaks" } });
db.users.updateOne({ "email": "tees@gmail.com" }, { $addToSet: { "followers": "Shoyeb" } });

db.users.updateMany(
  { "email": { $in: ["elahi@gmail.com", "tamzid@gmail.com", "tees@gmail.com"] } },
  { $addToSet: { "followers": { $each: ["Dayan", "Shaks","Shoyeb"] } } }
);

db.users.updateMany(
  { "email": { $in: ["tamzid@gmail.com", "tees@gmail.com"] } },
  { $addToSet: { "followers": { $each: ["Dayan", "Shaks","Shoyeb"] } } }
);

db.users.updateMany(
  { "email": { $in: ["tamzid@gmail.com", "tees@gmail.com"] } },
  { $addToSet: { "followers": { $each: ["RRK", "MKS","TAS"] } } }
);

db.users.updateMany(
  { "email": { $in: ["tamzid@gmail.com", "tees@gmail.com"] } },
  { $addToSet: { "following": { $each: ["TTB", "RRU","MA"] } } }
);

db.users.updateMany(
  { "email": { $in: ["tees@gmail.com"] } },
  { $addToSet: { "following": { $each: ["John", "Tinu","Tahsan"] } } }
);

//2.E
db.posts.insertMany([
  {
    "content": "Naam Chilona",
    "creation_time": ISODate("2010-09-09T12:00:00Z"),
    "user_id": "hudai@gmail.com",
    "likes": ["nazza@gmail.com","ridun@gmail.com"],
  },
  {
    "content": "Hariye Giyechi",
    "creation_time": ISODate("2012-09-09T12:00:00Z"),
    "user_id": "sadboy@gmail.com",
    "likes": ["sian@gmail.com","jawad@gmail.com"],
  },
  {
    "content": "Bhalobasha Tarpor",
    "creation_time": new Date(),
    "user_id": "lonelygirl@gmail.com",
    "likes": ["muiazza@gmail.com","mukitta@gmail.com"],
  },
 ]);

// 2.F
db.posts.updateMany(
    {"user_id":{ $in: ["bsdk@gmail.com", "kutia@gmail.com", "vulah123@gmail.com"] }},
    {$addToSet: { "comments": { $each: ["Shei", "Noice","Vala Lagsa"] } }}
);

db.posts.updateMany(
    {"user_id":"ping@gmail.com"},
    {$set : {"comments":"chop","comments":"amito valana","comments":"hehe"}}
);



//3.A
db.posts.find().sort({creation_time:-1});

//3.B
db.posts.find({"creation_time":{$gt:new Date(Date.now() - 24*60*60*1000)}});

//3.C
db.users.find({$where:"this.followers && this.followers.length>3"});

db.users.find({$where:"this.following && this.following.length>3"});




