const express = require('express');
const path = require('path');
const { connectDB } = require('./config/connectDB');
const db = require('./models');

const app = express();
const PORT = process.env.PORT || 8080;

// Middleware
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Initialize database and sync models
const initDB = async () => {
    try {
        await connectDB();
        await db.sequelize.sync({ alter: true });
        console.log('Database synchronized');
    } catch (error) {
        console.log('Error initializing database:', error);
    }
};
initDB();

// Routes
app.get('/', async (req, res) => {
    try {
        const users = await db.User.findAll();
        res.render('home', { users });
    } catch (error) {
        console.error('Error fetching users:', error);
        res.render('home', { users: [], error: 'Failed to fetch users' });
    }
});

// Create a new user
app.post('/users', async (req, res) => {
    try {
        await db.User.create(req.body);
        res.redirect('/');
    } catch (error) {
        console.error('Error creating user:', error);
        const users = await db.User.findAll();
        res.render('home', { users, error: 'Failed to create user' });
    }
});

// Delete a user
app.post('/users/delete/:id', async (req, res) => {
    try {
        await db.User.destroy({ where: { id: req.params.id } });
        res.redirect('/');
    } catch (error) {
        console.error('Error deleting user:', error);
        res.redirect('/');
    }
});

// Update user form
app.get('/users/edit/:id', async (req, res) => {
    try {
        const user = await db.User.findByPk(req.params.id);
        if (!user) {
            return res.redirect('/');
        }
        const users = await db.User.findAll();
        res.render('home', { users, editUser: user });
    } catch (error) {
        console.error('Error fetching user for edit:', error);
        res.redirect('/');
    }
});

// Update user
app.post('/users/update/:id', async (req, res) => {
    try {
        await db.User.update(req.body, { where: { id: req.params.id } });
        res.redirect('/');
    } catch (error) {
        console.error('Error updating user:', error);
        res.redirect('/');
    }
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});