var express = require('express');
var app = express();
var redis = require('redis');

var client = redis.createClient(6379, 'redis');
client.on("error", function (err) {
    console.error("Redis error", err);
});

app.get('/', function (req, res) {
    res.redirect('/index.html');
});

app.get('/account', function (req, res) {
    client.get('account', function (err, account) {
            var now = Date.now() / 1000;
            res.json( {
                "now": now,
                "account": account
            });
    });
});

app.post('/account', function (req, res) {
    client.set('account', 300);
});

app.use(express.static('files'));

var server = app.listen(8080, function () {
    console.log('WEBUI running on port 8080');
});
