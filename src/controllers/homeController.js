import db from '../models/index.js'; // Adjust the path as necessary

const getHomePage = async (req, res) => {
    try {
        let data = await db.User.findAll();
        return res.render('home.ejs');// Check if the database connection is established

    }
    catch (e) {
        console.log(e)
    }



    // or if you're not using a view engine:
    // return res.send('Home Page');
};

const getABC = (req, res) => {
    return res.render('sample.ejs');
    // or if you're not using a view engine:
    // return res.send('ABC Page');
};

module.exports = {
    getHomePage,
    getABC
};