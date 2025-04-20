const express = require('express');
const path = require('path');
const { connectDB } = require('./config/connectDB');
const homeRoutes = require('./routes/home');
const taiKhoanRoutes = require('./routes/taiKhoan');

require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 8080;

// View engine setup
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Database connection
connectDB();

// Routes
app.use('/', homeRoutes);
app.use('/taikhoan', taiKhoanRoutes);

// Start server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});