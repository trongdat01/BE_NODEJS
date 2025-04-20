const getHomePage = (req, res) => {
    return res.render('home.ejs');
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