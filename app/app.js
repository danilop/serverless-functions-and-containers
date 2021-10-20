const express = require('express');
const path = require('path')

const PORT = process.env.PORT || 3000;

const app = express();

app.use('/static', express.static(path.join(__dirname, 'public')))

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.post('/', (req, res) => {
  res.send('Thank you for posting!');
});

app.get('/gallery', (req, res) => {
  res.redirect('/static/gallery.html');
});

app.listen(PORT);
console.log(`Listening on port ${PORT}`);

module.exports = app