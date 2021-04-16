var faker = require('faker/locale/tr');

var avatarList = [
    "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/geisha_japanese_woman_avatar-512.png",
    "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/avocado_scream_avatar_food-512.png",
    "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/suicide_squad_woman_avatar_joker-512.png",
    "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/coffee_zorro_avatar_cup-512.png",
    "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/cloud_crying_rain_avatar-512.png",
    "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/santa_clous_christmas-512.png"
];
function between(min, max) {  
    return Math.floor(
      Math.random() * (max - min) + min
    )
  }


  /**
   * Shuffles array in place.
   * @param {Array} a items An array containing the items.
   */
  function shuffle(a) {
      var j, x, i;
      for (i = a.length - 1; i > 0; i--) {
          j = Math.floor(Math.random() * (i + 1));
          x = a[i];
          a[i] = a[j];
          a[j] = x;
      }
      return a;
  }
module.exports = () => {
    const data = { users: [] , feeds: [], messages: [] ,followers:[], followings:[],followers_request:[],user_bananas:[]};
    // Create 1000 users
    for (let i = 0; i < 1000; i++) {
        var followers = [];
        var followings = [];
        for(let j=0; j<15;j++){
            followers.push(faker.datatype.number({
                'min': 0,
                'max': 999
            }).toString());

        }
        for(let j=0; j<15;j++){
            followings.push(faker.datatype.number({
                'min': 0,
                'max': 999
            }).toString());

        }
      data.users.push({ id: i.toString(), name: faker.name.findName(),username:faker.internet.userName(),email:faker.internet.email() ,p_pic:avatarList[i%6], password:faker.internet.password(),followings:followings,followers:followers,accPrivate:Math.random % 2?true : false,accDeactive:Math.random % 2?true : false})
    }
    for(let i = 0; i < 1000; i++){
        var user = data.users[i];
        var temp = [];
        for(let j = 0; j<user.followers.length; j++){
            temp.push(data.users[user.followers[j]]);
        }
        data.followers.push(temp);
    }
    for(let i = 0; i < 1000; i++){
        var user = data.users[i];
        var temp = [];
        for(let j = 0; j<user.followings.length; j++){
            temp.push(data.users[user.followings[j]]);
        }
        data.followings.push(temp);
    }

    for(let i = 0; i < 1000; i++){
        var temp = [];
        var user = data.users[i];
        for (let j = 0; j < between(1,25);j++){
            var choice = between(0,user.followings.length-1);
            var selected = data.users[parseInt(user.followings[choice])];
            temp.push({id:selected.id,name:selected.name,username:selected.username,p_pic:selected.p_pic,content:faker.lorem.paragraph(),media:j % 3==0 ? faker.image.people():null});
        }
        for (let j = 0; j < between(1,25);j++)
            temp.push({id:user.id,name:user.name,username:user.username,p_pic:user.p_pic,content:faker.lorem.paragraph(),media:j % 3==0 ?faker.image.people():null});
        
        data.user_bananas.push(shuffle(temp));
    }
    for(let i = 0; i < 1000; i++){
        var temp = [];
        var user = data.users[i];
        for (let j = 0; j < between(1,25);j++){
            var choice = between(0,user.followings.length-1);
            var selected = data.users[parseInt(user.followings[choice])];
            temp.push({id:selected.id,name:selected.name,username:selected.username,p_pic:selected.p_pic,content:faker.lorem.paragraph(),media:j % 3==0 ? faker.image.people():null});
        }
        for (let j = 0; j < between(1,25);j++)
            temp.push({id:user.id,name:user.name,username:user.username,p_pic:user.p_pic,content:faker.lorem.paragraph(),media:j % 3==0 ?faker.image.people():null});
        
        data.feeds.push(shuffle(temp));
    }
    for(let i = 0; i < 1000; i++){
        var temp = [];
        var user = data.users[i];
        for (let j = 0; j < 50;j++){
            var choice = between(0,6);
            var id_ = between(0,1000);
            temp.push({id:j,text:faker.name.findName(),messageText:faker.lorem.paragraph(),p_pic:avatarList[choice],time:faker.time.recent()});
        }
        data.messages.push(temp);
    }
    return data
  }