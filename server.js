require("coffee-script"); 
var port =  process.argv[2] || process.env.PORT || 3000;
// ip=http://87.194.136.83/
app=require("./app")
app(port);
