express  = require("express")
Matrix   = require('./lib/matrix')
path     = require("path")
io       = require('socket.io')

app = express()
io.listen(app)

matrix = new Matrix

app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "/views", __dirname + "/views"
  app.set "view engine", "hbs"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, "/public"))

app.get "/", (req, res) ->
  res.render "index",
    title: 'Pixel Matrix'
    pixels: matrix.pixels

app.listen(3001);