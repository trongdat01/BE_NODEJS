require('dotenv').config();
const express = require('express');
const webRoutes = require('./routes/web');
const configViewEngine = require('./config/viewEngine');

const app = express();
const port = process.env.PORT;
const hostnam = process.env.HOSTNAME;

//config template engine
configViewEngine(app);

//khai bao route
app.use('/', webRoutes);






app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})